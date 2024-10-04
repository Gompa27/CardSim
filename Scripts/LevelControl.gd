extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%LevelSprite.frame = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_up_button_pressed() -> void:
	print(" Level Sprite Up", %LevelSprite.frame)
	if %LevelSprite.frame < 9 :
		%LevelSprite.frame += 1

func _on_down_button_pressed() -> void:
	print(" Level Sprite Down", %LevelSprite.frame)
	if %LevelSprite.frame > 0 :
		%LevelSprite.frame -= 1
