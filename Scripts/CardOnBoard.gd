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
		if (event is InputEventMouseButton) and (event.button_index == 1):
			if event.button_mask == 1:
				if cardHighLighted:
					var cardTemp = card.instantiate()
					get_tree().get_root().get_node("Main/CardHolder").add_child(cardTemp)
					Game.cardSelected = true
					if cardHighLighted:
						self.get_child(0).hide()
			elif event.button_mask == 0:
				if !Game.mouseOnHand:
					cardHighLighted = false
					self.get_child(0).show()
				else:
					self.queue_free()
					get_node("../../../CardContainer").placeCard()
				for i in get_tree().get_root().get_node("Main/CardHolder").get_child_count():
					get_tree().get_root().get_node("Main/CardHolder").get_child(i).queue_free()
				Game.cardSelected = false
