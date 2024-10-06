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
	
func _process(_delta):
	%Card.frame = 0 if isFaceDown else cardNumber
		
	if isCardSelected:
		self.global_position = get_global_mouse_position() -  _fixOffsetWhenRotate()
		NetworkManager.move_card(self)


func _on_gui_input(event: InputEvent) -> void:
	print('EVENT: ', event)
	#El evento es de mouse
	if event is InputEventMouseButton:
		#Es click direcho
		if event.button_index == 2:
			#Click
			if event.button_mask == 0 && get_parent().pileType == Util.PILE_TYPE.TABLE:
				isFaceDown = !isFaceDown
				NetworkManager.flip_card(self)
				
		#Es click izquierdo
		if event.button_index == 1:
			#Start dragging
			if event.button_mask == 1:
				_startDragging(event)
			elif event.button_mask == 0:
				_finishDragging()
				
func _startDragging(event: InputEventMouseButton):
	isCardSelected = true
	offsetMouse = event.position
	currentCardSelected = self

func _finishDragging():
	currentCardSelected = null
	var piles_nodes = Pile.piles
	var isReparented = false
	for pile in piles_nodes:
		if is_dragging_over(pile):
			self.reparent(pile)
			self.global_position = get_global_mouse_position() - _fixOffsetWhenRotate()

			isReparented = true
			NetworkManager.reparent_card(self)
			pass
	
	if self.get_parent() is Pile && !isReparented:
		var tableNode =get_tree().current_scene.get_node('%Table')
		self.isFaceDown = true
		self.reparent(tableNode)
		NetworkManager.reparent_card(self)
	isCardSelected = false
	offsetMouse = Vector2(0,0)


func is_dragging_over(pile: Pile) -> bool:
	var drop_area_rect = get_global_rect()
	var pile_rect = pile.get_rotated_rect()
	return drop_area_rect.intersects(pile_rect)


static func findCard(_cardNumber: int, _cardType: Util.CARD_TYPE):
	var cards = Card.cards_in_game
	for card in cards:
		if card.cardNumber == _cardNumber && card.cardType == _cardType:
			return card

func moveCard(_position: Vector2):
	self.global_position = _position
	
func flipCard():
	isFaceDown = !isFaceDown



func _fixOffsetWhenRotate():
	var dX = offsetMouse.x
	var dY = offsetMouse.y
	var rotation = self.get_global_transform().get_rotation()
	if rotation > 3: ### 3.14 === 180
		return Vector2(-dX, -dY)
	elif rotation > 1: ### 1.57 === 90
		return Vector2(-dY, dX)
	elif rotation < -1 :  ### -1.57 === 270
		return Vector2(dY, -dX)
	else:
		return offsetMouse
