extends Node

signal _on_update_players(players: Dictionary)
signal _on_update_decks()

var CARD_TREASURE_SCENE = load("res://Scenes/CardTreasure.tscn")

var cardSelected

var mouseOnPlacement = false
var mouseOnHand = false

var deck_doors: Array[int]= []
var deck_treasures: Array[int]= []
var discard_pile_doors: Array[int]= []
var discard_pile_treasures: Array[int] = []

var players: Dictionary = {}

func _ready():
	print("GAME INSTANCE", self.get_instance_id())

	fill_deck(deck_doors, Util.AMOUNT_DOORS_CARDS)
	fill_deck(deck_treasures, Util.AMOUNT_TREASURE_CARDS)
	
	deck_doors.shuffle()
	deck_treasures.shuffle()

func add_player(player: Dictionary):
	players[player.peer_id] = player
	emit_signal("_on_update_players", players)

func update_players(players: Dictionary):
	self.players =  players
	emit_signal("_on_update_players", players)

func update_decks(door: Array[int], treasure: Array[int], discard_door: Array[int], discard_treasure: Array[int]):
	deck_doors = door
	deck_treasures = treasure
	discard_pile_doors = discard_door
	discard_pile_treasures = discard_treasure
	emit_signal("_on_update_decks")


func draw_door():
	var card = deck_doors.pop_back()
	print("DRAW DOOR")
	emit_signal("_on_update_decks")
	return card
	
func discard_card(card: int, type: Util.DECK_TYPE):
	if type == Util.DECK_TYPE.DISCARD_DOOR:
		discard_pile_doors.append(card)
	elif type == Util.DECK_TYPE.DISCARD_TREASURE:
		discard_pile_treasures.append(card)
	
	emit_signal("_on_update_decks")

func draw_treasure():
	var card = deck_treasures.pop_back()
	emit_signal("_on_update_decks")
	return card

func shuffle_deck(type: Util.DECK_TYPE):
	if type == Util.DECK_TYPE.DRAW_DOOR:
		deck_doors.shuffle()
	elif type == Util.DECK_TYPE.DRAW_TREASURE:
		deck_treasures.shuffle()
	elif type == Util.DECK_TYPE.DISCARD_DOOR:
		deck_doors.append_array(discard_pile_doors)
		discard_pile_doors.clear()
		deck_doors.shuffle()
	elif type == Util.DECK_TYPE.DISCARD_TREASURE:
		deck_treasures.append_array(discard_pile_treasures)
		discard_pile_treasures.clear()
		deck_treasures.shuffle()
	emit_signal("_on_update_decks")
	
func get_deck(type: Util.DECK_TYPE):
	if type == Util.DECK_TYPE.DRAW_DOOR:
		return deck_doors
	elif type == Util.DECK_TYPE.DRAW_TREASURE:
		return deck_treasures
	elif type == Util.DECK_TYPE.DISCARD_DOOR:
		return discard_pile_doors
	elif type == Util.DECK_TYPE.DISCARD_TREASURE:
		return discard_pile_treasures


######################### UTILS ###################################
	
func fill_deck(deck: Array[int], amount: int):
	for i in range(1, amount):
		deck.append(i)
