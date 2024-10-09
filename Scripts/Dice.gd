extends Button

var isPlaying = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	NetworkManager.connect('_roll_dice', roll)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if isPlaying :
		for child in get_children():
			child.frame = randi_range(0,5)

func _on_pressed() -> void:
	NetworkManager.roll_dice()

func roll(number : int):
	isPlaying = true
	await get_tree().create_timer(3).timeout
	isPlaying = false
	get_child(0).frame = number
	get_child(1).frame = _throw_dice_no_repeat([number])
	get_child(2).frame = _throw_dice_no_repeat([number, get_child(1).frame])
	
	
func _throw_dice_no_repeat(noRepeatNumber: Array[int]):
	var numberSelected = noRepeatNumber[0]
	while (numberSelected in noRepeatNumber):
		numberSelected = randi_range(0,5)
	
	return numberSelected
	
