extends Node
signal _roll_dice(number : int)
	
const MAX_PEERS = 5
var connection_client = ENetMultiplayerPeer.new()

var multiplayer_api : MultiplayerAPI

func _process(_delta: float) -> void:
	if multiplayer_api && multiplayer_api.has_multiplayer_peer():
		multiplayer_api.poll()

######################## SERVER ########################
func host_server(port: int):
	connection_client.peer_connected.connect(_on_peer_connected)
	connection_client.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer_api = MultiplayerAPI.create_default_interface()
	connection_client.create_server(port, MAX_PEERS)
	get_tree().set_multiplayer(multiplayer_api, NetworkManager.get_path())
	multiplayer_api.multiplayer_peer = connection_client
	#print("SERVER OPEN", connection_client.get_connection_status())
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_peer_connected(peer_id):
	#print("SERVER - NUEVO PEER CONECTADA, PEER_ID: {0}".format([peer_id]))
	await get_tree().create_timer(1).timeout
	#print("SERVER - PEERS CONECTADAS: {0}".format([multiplayer.get_peers()]))
		

func _on_peer_disconnected(peer_id):
	print("SERVER - PEER DESCONECTADA: {0}".format([peer_id]))
	

######################## CLIENT ########################

func connect_server(ip_address: String, port: int, username: String):
	connection_client.create_client(ip_address, port)
	multiplayer_api = MultiplayerAPI.create_default_interface()
	multiplayer_api.connected_to_server.connect(_on_connection_succeeded.bind(username))
	multiplayer_api.connection_failed.connect(_on_connection_failed)
	get_tree().set_multiplayer(multiplayer_api, NetworkManager.get_path()) 
	multiplayer_api.multiplayer_peer = connection_client
	#print("CLIENTE - UNIQUE_ID: {0}".format([multiplayer_api.get_unique_id()]))



func _on_connection_succeeded(username: String):
	await get_tree().create_timer(1).timeout
	#print("CLIENTE CONECTADO - PEERS CONECTADAS {0}".format([multiplayer.get_peers()]))
	login(username)
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
	
	

func _on_connection_failed():
	print("Custom Client _on_connection_failed")
	
	
######################## GAME LOGIC ########################

@rpc("authority")
func rpc_update_deck(pileType: Util.PILE_TYPE, newPile: Array[int]):
	var pile = Pile.findPile(pileType)
	pile.updatePile(newPile)
	
@rpc("authority")
func rpc_send_cards_to(oldPileType: Util.PILE_TYPE, newPileType: Util.PILE_TYPE):
	var pile = Pile.findPile(oldPileType)
	pile.send_cards_to(newPileType)

@rpc("any_peer")
func rpc_update_players(game: Dictionary):
	Game.deserialize(game)

@rpc("any_peer")
func rpc_login(username: String):
	var peerId = multiplayer.get_remote_sender_id()
	if (peerId == 0):
		peerId = 1
		
	var player = {
		"peer_id": peerId, 
		"username" :username
	}
	Game.add_player(player)
	rpc_update_players.rpc(Game.serialize())

@rpc("any_peer")
func rpc_set_dice(number: int):
	emit_signal('_roll_dice', number)

@rpc("any_peer")
func rpc_roll_dice():
	var random_numer = randi_range(0,5)
	rpc_set_dice(random_numer)
	rpc_set_dice.rpc(random_numer)
	
@rpc("any_peer")
func rpc_flip_card(cardNumber: int, cardType: Util.CARD_TYPE):
	var card = Card.findCard(cardNumber, cardType)
	card.flipCard()
	
@rpc("any_peer")
func rpc_move_card(cardNumber: int, position: Vector2, cardType: Util.CARD_TYPE):
	var peerId = multiplayer.get_remote_sender_id()
	var playerPosition = Game.playersPositions.find(peerId)
	var card = Card.findCard(cardNumber, cardType)
	#var cardPosition = Util.calculate_position_for_user(card, position, playerPosition)
	var cardRotation = Util.calculate_rotation_for_user(playerPosition)
	card.rotation_degrees = cardRotation
	card.moveCard(position)
	
@rpc("any_peer")
func rpc_reparent_card(cardNumber: int, cardType: Util.CARD_TYPE, pileType: Util.PILE_TYPE):
	var card = Card.findCard(cardNumber, cardType)
	var pile = Pile.findPile(pileType)
	card.reparent(pile)
	
@rpc("any_peer")
func rpc_shuffle_deck(pileType: Util.PILE_TYPE):
	var pile = Pile.findPile(pileType)
	if pileType == Util.PILE_TYPE.DISCARD_DOOR:
		pile.send_cards_to(Util.PILE_TYPE.DOOR)
		pile =  Pile.findPile(Util.PILE_TYPE.DOOR)
		rpc_send_cards_to.rpc(pileType, Util.PILE_TYPE.DOOR)
	elif pileType == Util.PILE_TYPE.DISCARD_TREASURE:
		pile.send_cards_to(Util.PILE_TYPE.TREASURE)
		pile =  Pile.findPile(Util.PILE_TYPE.TREASURE)
		rpc_send_cards_to.rpc(pileType, Util.PILE_TYPE.TREASURE)
		
	var newOrder= pile.shuffle()
	rpc_update_deck.rpc(pileType, newOrder)
	
@rpc("any_peer")
func rpc_change_seat(newPlayerPosition: int):
	var peerId = multiplayer.get_remote_sender_id()
	if (peerId == 0):
		peerId = 1
	
	var realPosition = Game.playersPositions.find(peerId)
	var newPosition = realPosition + newPlayerPosition
	if newPosition > 3:
		newPosition -= 4
	
	Game.change_position(peerId, newPosition)
	rpc_update_players.rpc(Game.serialize())

func login(username: String):
	rpc_login.rpc(username)

func roll_dice():
	if multiplayer.is_server():
		rpc_roll_dice()
	else:
		rpc_roll_dice.rpc_id(1)
		
func flip_card(card: Card):
	rpc_flip_card.rpc(card.cardNumber, card.cardType)

func move_card(card: Card):
	rpc_move_card.rpc(card.cardNumber, card.global_position, card.cardType)

func reparent_card(card: Card):
	rpc_reparent_card.rpc(card.cardNumber, card.cardType, card.get_parent().pileType)

func shuffle_deck(pileType: Util.PILE_TYPE):
	if multiplayer.is_server():
		rpc_shuffle_deck(pileType)
	else:
		rpc_shuffle_deck.rpc_id(1, pileType)

func change_seat(newPlayerPosition: int):
	if multiplayer.is_server():
		rpc_change_seat(newPlayerPosition)
	else:
		rpc_change_seat.rpc_id(1, newPlayerPosition)
