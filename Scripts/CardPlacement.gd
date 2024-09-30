extends Control

@onready var card = preload("res://Scenes/CardOnBoard.tscn")

func _on_mouse_entered() -> void:
	Game.mouseOnPlacement = true


func _on_mouse_exited() -> void:
	Game.mouseOnPlacement = false

func placeCard():
	var cardTemp = card.instantiate()
	get_node("CardContainer").add_child(cardTemp)
	
