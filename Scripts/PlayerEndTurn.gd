extends TextureButton

@export var playerTurn: int

func _process(delta):
	self.visible = playerTurn == Game.currentPlayerTurn

func _on_pressed():
	if playerTurn == Game.myPosition:
		NetworkManager.end_turn()
