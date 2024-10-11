extends Node2D


@export var PlayerPointers: Array[Sprite2D]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	NetworkManager.update_pointer(get_global_mouse_position())
	
	var i = 0
	for pointer in Game.playersPointers:
		PlayerPointers[i].global_position = pointer
		i +=1
