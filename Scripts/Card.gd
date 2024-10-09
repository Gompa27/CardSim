class_name Card
extends  Control

signal change_pos(pos: Vector2)

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
		self.global_position = get_global_mouse_position() - offsetMouse
		NetworkManager.move_card(self)


func _on_gui_input(event: InputEvent) -> void:
	#El evento es de mouse
	if event is InputEventMouseButton:
		#Es click direcho
		if event.button_index == 2:
			#Click
			if event.button_mask == 0 && get_parent().pileType in Util.PILE_ALL_TABLES:
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
	self.move_to_front()


func _finishDragging():
	currentCardSelected = null
	var piles_nodes = Pile.piles
	var isReparented = false
	var needsReparented = true
	for pile in piles_nodes:
		if is_dragging_over(pile):
			if pile == get_parent():
				needsReparented = false
			else:
				if get_parent() is Pile && get_parent().pileType in Util.PILE_HAND_PLAYER:
					self.isFaceDown = true
				self.reparent(pile)
				self.global_position = get_global_mouse_position() - offsetMouse
				isReparented = true
				NetworkManager.reparent_card(self)
				pass
	
	if self.get_parent() is Pile && !isReparented && needsReparented:
		var tableNode =get_tree().current_scene.get_node('%Table')
		self.isFaceDown = true
		self.reparent(tableNode)
		self.global_position = get_global_mouse_position() - offsetMouse
		NetworkManager.reparent_card(self)
	isCardSelected = false
	offsetMouse = Vector2(0,0)


func is_dragging_over(pile: Pile) -> bool:
	#var drop_area_rect = get_global_rect()
	var mouse_pos = get_global_mouse_position()
	var pile_rect = pile.get_global_rect()
	return pile_rect.has_point(mouse_pos)

static func findCard(_cardNumber: int, _cardType: Util.CARD_TYPE):
	var cards = Card.cards_in_game
	for card in cards:
		if card.cardNumber == _cardNumber && card.cardType == _cardType:
			return card

func moveCard(_position: Vector2):
	self.global_position = _position
	self.move_to_front()
	
func flipCard():
	isFaceDown = !isFaceDown
