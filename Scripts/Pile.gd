class_name Pile
extends Container

static var piles: Array[Pile] = []
@export var pile_name: String

func _ready():
	piles.append(self)


static func findPile(pileName: String):
	for pile in piles:
		if pile.pile_name == pileName:
			return pile
