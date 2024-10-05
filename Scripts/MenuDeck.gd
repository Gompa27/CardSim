extends Control

#var _last_mouse_position
@export var popupMenu: PopupMenu

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_RIGHT:
		var _last_mouse_position = get_global_mouse_position()
		popupMenu.popup(Rect2(_last_mouse_position.x, _last_mouse_position.y, popupMenu.size.x, popupMenu.size.y))
