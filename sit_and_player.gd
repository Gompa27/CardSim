extends Control

@export var playerPosition: int

func _ready():
	if playerPosition == 0:
		%SitHere.hide()

func _process(delta):
	%SitHere.disabled = playerPosition >= Game.playersPositions.size()
	
	if playerPosition < Game.playersPositions.size():
		%PlayerName.text = Game.players[Game.playersPositions[playerPosition]].username
	else:
		%PlayerName.text = 'Lugar vacio'

func _on_sit_here_pressed():
	NetworkManager.change_seat(playerPosition)
