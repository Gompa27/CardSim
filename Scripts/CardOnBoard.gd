extends Container


@onready var card = preload("res://Scenes/CardHolder.tscn")
var startPosition
var cardHighLighted = false

func _ready():
	startPosition = self.position

func _on_mouse_entered() -> void:
	$Anim.play("Select")
	cardHighLighted = true

func _on_mouse_exited() -> void:
	$Anim.play("Deselect")
	cardHighLighted = false


func _on_gui_input(event: InputEvent) -> void:
	pass # Replace with function body.
