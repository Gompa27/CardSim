class_name Card
extends  Draggable

static var cards_doors_in_game: Array[Card] = []
static var cards_treasures_in_game: Array[Card] = []

var cardNumber = 0
var isShowingCard = false

func _ready():
	if self.get_meta('TYPE') == 'DOOR':
		cards_doors_in_game.append(self)
	elif self.get_meta('TYPE') == 'TREASURE':
		cards_treasures_in_game.append(self)
	
func _process(delta):
	if isShowingCard:
		%Card.frame = cardNumber
	else:
		%Card.frame = 0
