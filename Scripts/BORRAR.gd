extends Control

func _on_draw_door_pressed():
	Game.draw_door()

func _on_discard_door_pressed():
	NetworkManager.discard_card(randi_range(1, Util.AMOUNT_DOORS_CARDS), Util.DECK_TYPE.DISCARD_DOOR)

func _on_draw_treasure_pressed():
	Game.draw_treasure()


func _on_discard_treasure_pressed():
	NetworkManager.discard_card(randi_range(1, Util.AMOUNT_TREASURE_CARDS), Util.DECK_TYPE.DISCARD_TREASURE)
