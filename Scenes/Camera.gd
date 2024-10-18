extends Camera2D

var dragging: bool = false
var mouse_start_pos
var screen_start_position
const MAX_ZOOM_OUT = Vector2(0.5,0.5)
const MAX_ZOOM_IN = Vector2(1,1)
const ZOOM_VARIANCE = Vector2(0.05,0.05)


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_zoomIn()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_zoomOut()
		elif event.button_index == 3:
			print(event)
			if event.button_mask == 4:
				mouse_start_pos = event.position
				screen_start_position = position
				dragging = true
			elif event.button_mask == 0:
				dragging = false
				mouse_start_pos = null
				
	elif event is InputEventMouseMotion and dragging:
		position = zoom * (mouse_start_pos - event.position) + screen_start_position


func _zoomIn():
	if self.zoom < MAX_ZOOM_IN:
		self.zoom += ZOOM_VARIANCE

	
func _zoomOut():
	if self.zoom > MAX_ZOOM_OUT:
		self.zoom -= ZOOM_VARIANCE
