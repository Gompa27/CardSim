class_name Draggable
extends Control

@onready var card = preload("res://Scenes/CardHolder.tscn")

var startPosition
var offsetMouse: Vector2
#var cardHighLighted

func _ready():
	startPosition = self.position

func _process(delta: float) -> void:
	if cardSelected:
		self.global_position = get_global_mouse_position() - offsetMouse
		NetworkManager.move_card(self.global_position)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == 1:
		if event.button_mask == 1:
			cardSelected = true
			offsetMouse = event.position
		elif event.button_mask == 0:
			cardSelected = false
			offsetMouse = Vector2(0,0)
