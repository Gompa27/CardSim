class_name PilePreview
extends Window

@export var pile: Pile
@export var list: Container

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_about_to_popup():
	
	print("Pile: ",pile)
	for child in list.get_children():
		child.queue_free()
		
	for child in pile.get_children():
		if child is Card:
			var nueva = child.duplicate()
			list.add_child(nueva)
