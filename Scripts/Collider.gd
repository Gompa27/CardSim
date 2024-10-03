extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func check_collide(control_a: Control) -> bool:
	var rect_a = control_a.get_rect()
	var rect_b = self.get_rect()
	
	# Convertir las posiciones relativas a la escena para obtener posiciones globales
	var global_rect_a = rect_a.transformed(control_a.get_global_transform())
	var global_rect_b = rect_b.transformed(self.get_global_transform())
	
	# Verificar si los rectángulos se intersectan
	return global_rect_a.intersects(global_rect_b)
