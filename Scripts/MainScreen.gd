extends Node

@export var card_door_scene: PackedScene
@export var card_treasure_scene: PackedScene
@export var pile_doors: Control
@export var pile_treaasures: Control

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
	NetworkManager.shuffle_deck(id)

func _update_dot(pos: Vector2):
	%dot.position = pos
