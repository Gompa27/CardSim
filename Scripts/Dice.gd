extends Button

var isPlaying = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	NetworkManager.connect('_roll_dice', roll)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isPlaying :
		get_child(0).frame = randi_range(0,5)

func _on_pressed() -> void:
	NetworkManager.roll_dice()

func roll(number : int):
	isPlaying = true
	await get_tree().create_timer(3).timeout
	isPlaying = false
	get_child(0).frame = number
	
	
