class_name Pile
extends Control

static var piles: Array[Pile] = []
@export var pileType: Util.PILE_TYPE
#@export var canSeeCards: bool
@export var pileName: String
@export var rotationIntersect: int
@export var playerNumber: int

func _ready():
	piles.append(self)


static func findPile(pileType: Util.PILE_TYPE):
	for pile in piles:
		if pile.pileType == pileType:
			return pile


func shuffle():
	if self.pileType == Util.PILE_TYPE.DOOR || self.pileType == Util.PILE_TYPE.TREASURE:
		var cardsInPile: Array[int] = []
		for child in get_children():
			cardsInPile.append(child.cardNumber)
		
		cardsInPile.shuffle()
		cardsInPile.shuffle()
		cardsInPile.shuffle()
		updatePile(cardsInPile)
			
		return cardsInPile

func updatePile(newOrder: Array[int]):
	var cardType = _getTypeCard()
	for i in range(newOrder.size()):
		var card = Card.findCard(newOrder[i], cardType)
		self.move_child(card, i)


func _getTypeCard():
	if self.pileType == Util.PILE_TYPE.DOOR || self.pileType == Util.PILE_TYPE.DISCARD_DOOR:
		return Util.CARD_TYPE.DOOR
	elif self.pileType == Util.PILE_TYPE.TREASURE || self.pileType == Util.PILE_TYPE.DISCARD_TREASURE:
		return Util.CARD_TYPE.TREASURE
	
	return null	
	
func send_cards_to(pileType: Util.PILE_TYPE):
	var newPile = findPile(pileType)
	for child in get_children():
		child.isFaceDown = true
		child.reparent(newPile)


func _on_child_entered_tree(node):
	Game.playersPositions
	if node is Card:
		if pileType == Util.PILE_TYPE.DOOR || pileType == Util.PILE_TYPE.TREASURE:
			node.isFaceDown = true
		if pileType == Util.PILE_TYPE.DISCARD_DOOR || pileType == Util.PILE_TYPE.DISCARD_TREASURE:
			node.isFaceDown = false
		if pileType in Util.PILE_HAND_PLAYER:
			node.isFaceDown = playerNumber != Game.myPosition
#


func get_rotated_rect() -> Rect2:
	var curr = get_global_rect()
	var posX = curr.position.x
	var posY = curr.position.y
	var sizeX = curr.size.x
	var sizeY = curr.size.y
	match rotationIntersect:
		0:
			return curr
		90:
			return Rect2(Vector2(posX - sizeY, posY), Vector2(sizeY, sizeX))
		180:
			return Rect2(Vector2(posX - sizeX, posY - sizeY), curr.size)
		270:
			return Rect2(Vector2(posX, posY - sizeX), Vector2(sizeY, sizeX))
		_:
			return curr  # Por defecto sin rotación
