class_name Card
extends  Control

static var cards_in_game: Array[Card] = []

var cardNumber = 0
var isFaceDown = true
var offsetMouse: Vector2
var isCardSelected: bool = false
var cardType: Util.CARD_TYPE

func _ready():
	cards_in_game.append(self)
	
func _process(delta):
	%Card.frame = 0 if isFaceDown else cardNumber
		
	if isCardSelected:
		self.global_position = get_global_mouse_position() - offsetMouse
		NetworkManager.move_card(self)


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 2:
			if event.button_mask == 0:
				isFaceDown = !isFaceDown
				NetworkManager.flip_card(self)
				
		if event.button_index == 1:
			if event.button_mask == 1:
				isCardSelected = true
				offsetMouse = event.position
			elif event.button_mask == 0:
				isCardSelected = false
				offsetMouse = Vector2(0,0)



static func findCard(cardNumber: int, cardType: Util.CARD_TYPE):
	var cards = Card.cards_in_game
	for card in cards:
		if card.cardNumber == cardNumber && card.cardType == cardType:
			return card

func moveCard(position: Vector2):
	self.global_position = position
	
func flipCard():
	isFaceDown = !isFaceDown
