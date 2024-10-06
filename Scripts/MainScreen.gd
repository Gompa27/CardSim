extends Node

@export var card_door_scene: PackedScene
@export var card_treasure_scene: PackedScene
@export var pile_doors: Pile
@export var pile_treaasures: Pile
@export var pile_discard_doors: Pile
@export var pile_discard_treaasures: Pile
@export var pilePreview: PilePreview

func _ready():
	_create_cards(Util.AMOUNT_DOORS_CARDS, card_door_scene, pile_doors, Util.CARD_TYPE.DOOR)
	_create_cards(Util.AMOUNT_TREASURE_CARDS, card_treasure_scene, pile_treaasures, Util.CARD_TYPE.TREASURE)

func _create_cards(amount: int, scene: PackedScene, newParent: Control, cardType: Util.CARD_TYPE):
	for cardNumber in range(1, amount):
		var card = scene.instantiate()
		card.cardNumber = cardNumber
		card.isFaceDown = newParent.get_meta('face_down')
		card.visible = true
		card.z_index = 50
		card.cardType = cardType
		newParent.add_child(card)

func _on_shuffle_menu_id_pressed(id):
	if id in [0,1,2,3]:
		NetworkManager.shuffle_deck(id)
	if id == 6: # Ver descarte puertas
		pilePreview.pile = pile_discard_doors
		pilePreview.popup()	
	if id == 7: # Ver descarte puertas
		pilePreview.pile = pile_discard_treaasures
		pilePreview.popup()
		


func _process(delta):
	var i = 0
	for playerNameLabel in get_tree().get_nodes_in_group('playerName'):
		if i < Game.playersPositions.size():
			playerNameLabel.text = Game.players[Game.playersPositions[i]].username
		else:
			playerNameLabel.text = 'Lugar vacio'
		i += 1




func _on_sit_button_1_pressed():
	NetworkManager.change_seat(0)


func _on_sit_button_2_pressed():
	NetworkManager.change_seat(1)


func _on_sit_button_3_pressed():
	NetworkManager.change_seat(2)

func _on_sit_button_4_pressed():
	NetworkManager.change_seat(3)
