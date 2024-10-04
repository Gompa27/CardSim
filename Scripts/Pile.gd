class_name Pile
extends Container

static var piles: Array[Pile] = []
@export var pileType: Util.PILE_TYPE

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
