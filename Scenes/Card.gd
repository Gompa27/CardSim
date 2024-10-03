class_name Card
extends Container

static var cards: Array[Card] = []

var cardNumber = 0
var isShowingCard = false
var cardType 

func _ready():
	cards.append(self)
