class_name Card
extends  Draggable

static var cards_doors_in_game: Array[Card] = []
static var cards_treasures_in_game: Array[Card] = []

var cardNumber = 0
var isFaceDown = true

func _ready():
	if self.get_meta('TYPE') == 'DOOR':
		cards_doors_in_game.append(self)
	elif self.get_meta('TYPE') == 'TREASURE':
		cards_treasures_in_game.append(self)
	
func _process(delta):
	super(delta)
	if isFaceDown:
		%Card.frame = 0
	else:
		%Card.frame = cardNumber


func _on_gui_input(event: InputEvent) -> void:
	super(event)
	if event is InputEventMouseButton and event.button_index == 2:
		if event.button_mask == 0:
			print('ASDASDASD')
			isFaceDown = !isFaceDown
