extends Control

var level = 1
@export var playerNumber: int 
@export var bgcolor: Color
# Called when the node enters the scene tree for the first time.
func _ready():
	%Label.text = str(level)
	Game.connect('_on_change_level', change_level)
	
	var styleBox =  StyleBoxFlat.new() 
	styleBox.bg_color = bgcolor
	%Label.add_theme_stylebox_override("panel", styleBox)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func change_level( _playerNumber:int , _level:int):
	if playerNumber == _playerNumber:
		level = _level
		%Label.text = str(level)	

func _on_add_level_pressed():
	level +=1
	%Label.text = str(level)
	NetworkManager.change_level(playerNumber,level)


func _on_remove_level_pressed():
	level -=1
	%Label.text = str(level)
	NetworkManager.change_level(playerNumber, level)
