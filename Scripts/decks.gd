extends Control

func _ready():
	Game.connect("_on_update_decks", update_decks)
	var amountDeckDoor = Game.deck_doors.size()
	var amountDeckTreasures = Game.deck_treasures.size()
	
	clone_and_fill(%ExampleDoor, amountDeckDoor-1)
	clone_and_fill(%ExampleDiscardDoor, amountDeckDoor-1)
	
	clone_and_fill(%ExampleTreasure, amountDeckTreasures-1)
	clone_and_fill(%ExampleDiscardTreasure, amountDeckTreasures-1)

	update_decks()

func update_decks():
	var amountDeckDoor = Game.deck_doors.size()
	for i in range(0, Game.DOORS_CARDS-1):
		%DeckDoors.get_child(i).visible = (i < amountDeckDoor)
	
	var amountDeckTreasures = Game.deck_treasures.size()
	for i in range(0, Game.TREASURE_CARDS-1):
		%DeckTreasures.get_child(i).visible = (i < amountDeckTreasures)
	
	%door.text = str(amountDeckDoor)
	%treasure.text = str(amountDeckTreasures)
	
	var amountDiscardDoor = Game.discard_pile_doors.size()
	if amountDiscardDoor > 0:
		for i in range(0, Game.DOORS_CARDS-1):
			var control = %DiscardPileDoors.get_child(i)
			var show =(i < amountDiscardDoor) 
			control.visible = show
			if show == true:
				control.get_child(0).frame = Game.discard_pile_doors[i]

	var amountDiscardTreasures = Game.discard_pile_treasures.size()
	if amountDiscardTreasures > 0:
		for i in range(0, Game.TREASURE_CARDS-1):
			var control = %DiscardPileTreasures.get_child(i)
			var show =(i < amountDiscardTreasures) 
			control.visible = show
			if show == true:
				control.get_child(0).frame = Game.discard_pile_treasures[i]




func clone_and_fill(control: Control, amount: int):
	var last_cloned = control
	for i in amount:
		var cloned = last_cloned.duplicate()
		cloned.position += Vector2(0,1)
		last_cloned.get_parent().add_child(cloned)
		last_cloned = cloned
