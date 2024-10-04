class_name Card
extends  Control

static var cards_in_game: Array[Card] = []
static var currentCardSelected: Card

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
	#El evento es de mouse
	if event is InputEventMouseButton:
		#Es click direcho
		if event.button_index == 2:
			#Click
			if event.button_mask == 0:
				isFaceDown = !isFaceDown
				NetworkManager.flip_card(self)
				
		#Es click izquierdo
		if event.button_index == 1:
			#Start dragging
			if event.button_mask == 1:
				isCardSelected = true
				offsetMouse = event.position
				currentCardSelected = self
				
			#Finish dragging
			elif event.button_mask == 0:
				isCardSelected = false
				offsetMouse = Vector2(0,0)
				currentCardSelected = null
				if Pile.currentPile:
					self.reparent(Pile.currentPile)


static func findCard(cardNumber: int, cardType: Util.CARD_TYPE):
	var cards = Card.cards_in_game
	for card in cards:
		if card.cardNumber == cardNumber && card.cardType == cardType:
			return card

func moveCard(position: Vector2):
	self.global_position = position
	
func flipCard():
	isFaceDown = !isFaceDown
