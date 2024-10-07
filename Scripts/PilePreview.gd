class_name PilePreview
extends Window

@export var pile: Pile
@export var list: Container

var listCard: Array[Card]
var cardSelected: int
var controlSelected: Control

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	%DrawCard.disabled = cardSelected == null


func _on_about_to_popup():
	NetworkManager.view_discard()
	cardSelected = -1
	listCard = []
	controlSelected = null
	for child in list.get_children():
		child.queue_free()
		
	var index = pile.get_child_count()-1
	for child in pile.get_children():
		if child is Card:
			var control = Control.new()
			control.connect("gui_input", _on_select_card.bind(control, index))
			control.custom_minimum_size = Vector2(240,400)
			var sprite = child.get_child(0).duplicate() as AnimatedSprite2D
			sprite.scale = Vector2(0.6,0.6)
			control.add_child(sprite)
			list.add_child(control)
			list.move_child(control, 0)
			listCard.push_front(child)
			index-=1


func _on_close_requested():
	NetworkManager.close_discard()
	hide()
	
func _on_select_card(event: InputEvent, control: Control, cardIndex: int):

	
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		if cardIndex != cardSelected:
			if controlSelected:
				controlSelected.position -= Vector2( 0, 40)
			cardSelected = cardIndex
			controlSelected = control
			control.position.y = 40



func _on_draw_card_pressed():
	var card = listCard[cardSelected]
	card.position.y += 50
	hide()
