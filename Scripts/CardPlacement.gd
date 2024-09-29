extends Control

@onready var card = preload("res://Scenes/CardOnBoard.tscn")

func _on_mouse_entered() -> void:
	Game.mouseOnPlacement = true


func _on_mouse_exited() -> void:
	Game.mouseOnPlacement = false

func placeCard():
	var cardTemp = card.instantiate()
	#var projectResolution = ProjectSettings.get_setting("display/window/size/viewport_width")
	#var projectResolutionHeight = ProjectSettings.get_setting("display/window/size/viewport_height")
	#cardTemp.global_position = Vector2(projectResolution/2, projectResolutionHeight/2) - self.position
	#add_child(cardTemp)
	get_node("CardContainer").add_child(cardTemp)
	
