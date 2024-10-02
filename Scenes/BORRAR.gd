extends Control

func _on_draw_door_pressed():
	Game.draw_door()

func _on_discard_door_pressed():
	Game.discard_door(randi_range(1, Game.DOORS_CARDS))


func _on_draw_treasure_pressed():
	Game.draw_treasure()


func _on_discard_treasure_pressed():
	Game.discard_treasure(randi_range(1, Game.TREASURE_CARDS))
