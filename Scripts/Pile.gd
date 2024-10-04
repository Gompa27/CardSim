class_name Pile
extends Container


static var currentPile: Container

func _on_mouse_exited():
	currentPile = null


func _on_mouse_entered():
	currentPile = self
