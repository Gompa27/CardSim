extends Panel

func _on_shuffle_doors_pressed():
	NetworkManager.shuffle_deck(Util.DECK_TYPE.DRAW_DOOR)


func _on_shuffle_treasures_pressed():
	NetworkManager.shuffle_deck(Util.DECK_TYPE.DRAW_TREASURE)


func _on_shuffle_discard_doors_pressed():
	NetworkManager.shuffle_deck(Util.DECK_TYPE.DISCARD_DOOR)


func _on_shuffle_discard_treasures_pressed():
	NetworkManager.shuffle_deck(Util.DECK_TYPE.DISCARD_TREASURE)
