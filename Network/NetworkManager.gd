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
	print("SERVER OPEN", connection_client.get_connection_status())
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_peer_connected(peer_id):
	print("SERVER - NUEVO PEER CONECTADA, PEER_ID: {0}".format([peer_id]))
	await get_tree().create_timer(1).timeout
	print("SERVER - PEERS CONECTADAS: {0}".format([multiplayer.get_peers()]))

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
	print("CLIENTE - UNIQUE_ID: {0}".format([multiplayer_api.get_unique_id()]))



func _on_connection_succeeded(username: String):
	await get_tree().create_timer(1).timeout
	print("CLIENTE CONECTADO - PEERS CONECTADAS {0}".format([multiplayer.get_peers()]))
	login(username)
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
	
	

func _on_connection_failed():
	print("Custom Client _on_connection_failed")
	
	
######################## GAME LOGIC ########################

@rpc("authority")
func rpc_update_decks(door: Array[int], treasure: Array[int], discard_door: Array[int], discard_treasure: Array[int]):
	Game.update_decks(door, treasure, discard_door, discard_treasure)
	print("ACTUALIAZ DECK")

@rpc("any_peer")
func rpc_update_players(players: Dictionary):
	Game.players = players

@rpc("any_peer")
func rpc_login(username: String):
	var player = {
		"peer_id": multiplayer.get_remote_sender_id(), 
		"username" :username
	}
	Game.add_player(player)
	rpc_update_players.rpc(Game.players)

@rpc("any_peer")
func rpc_discard_card(card: int, type: Util.DECK_TYPE):
	Game.discard_card(card, type)

@rpc("any_peer")
func rpc_shuffle_deck(type: Util.DECK_TYPE):
	Game.shuffle_deck(type)
	print("SERVER MEZCLA MASO")
	rpc_update_decks.rpc(Game.deck_doors, Game.deck_treasures, Game.discard_pile_doors, Game.discard_pile_treasures)

@rpc("any_peer")
func rpc_set_dice(number: int):
	emit_signal('_roll_dice', number)

@rpc("any_peer")
func rpc_roll_dice():
	var random_numer = randi_range(0,5)
	rpc_set_dice(random_numer)
	rpc_set_dice.rpc(random_numer)


func login(username: String):
	rpc_login.rpc(username)
	
func discard_card(card: int, type: Util.DECK_TYPE):
	rpc_discard_card(card, type)
	rpc_discard_card.rpc(card, type)

func shuffle_deck(type: Util.DECK_TYPE):
	if multiplayer.is_server():
		rpc_shuffle_deck(type)
	else:
		rpc_shuffle_deck.rpc_id(1, type)

func roll_dice():
	if multiplayer.is_server():
		rpc_roll_dice()
	else:
		rpc_roll_dice.rpc_id(1)
