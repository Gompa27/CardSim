extends Node

@export var card_door_scene: PackedScene
@export var card_treasure_scene: PackedScene
@export var pile_doors: Control
@export var pile_treaasures: Control

func _ready():
	_create_cards(Util.AMOUNT_DOORS_CARDS, card_door_scene, pile_doors)
	_create_cards(Util.AMOUNT_TREASURE_CARDS, card_treasure_scene, pile_treaasures)

func _create_cards(amount: int, scene: PackedScene, parent: Control):
	for cardNumber in range(1, amount):
		var instance = scene.instantiate()
		instance.cardNumber = cardNumber
		instance.isFaceDown = parent.get_meta('face_down')
		instance.visible = true
		instance.z_index = 50
		parent.add_child(instance)
