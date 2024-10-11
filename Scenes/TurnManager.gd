extends Control


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var turn = 0
	for coin in get_tree().get_nodes_in_group('endTurnButton'):
		coin.visible = turn == Game.currentPlayerTurn
		turn +=1

func _on_player_1_end_turn_pressed():
	_end_turn(0)

func _on_player_2_end_turn_pressed():
	_end_turn(1)

func _on_player_3_end_turn_pressed():
	_end_turn(2)

func _on_player_4_end_turn_pressed():
	_end_turn(3)

func _end_turn(player: int):
	if player == Game.myPosition:
		NetworkManager.end_turn()
