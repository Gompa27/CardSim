extends HBoxContainer


signal _on_move_up(playerId:String)
signal _on_move_down(playerId:String)

@export var playerName: String
@export var playerId: String


func _on_move_up_pressed():
	emit_signal("_on_move_up", playerId)


func _on_move_down_pressed():
	emit_signal("_on_move_down", playerId)
