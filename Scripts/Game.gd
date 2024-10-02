extends Node

signal _on_update_players(players: Dictionary)
signal _on_update_decks()

const DOORS_CARDS = 95
const TREASURE_CARDS = 73

enum DECK_TYPE {
	DRAW_DOOR,
	DRAW_TREASURE,
	DISCARD_DOOR,
	DISCARD_TREASURE
}


var cardSelected
var mouseOnPlacement = false
var mouseOnHand = false

var deck_doors: Array[int]= []
var deck_treasures: Array[int]= []
var discard_pile_doors: Array[int]= []
var discard_pile_treasures: Array[int]= []


var players: Dictionary = {}

func _ready():
	fill_deck(deck_doors, DOORS_CARDS)
	fill_deck(deck_treasures, TREASURE_CARDS)
	
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
	
func discard_card(card: int, type: DECK_TYPE):
	if type == DECK_TYPE.DISCARD_DOOR:
		discard_pile_doors.append(card)
	elif type == DECK_TYPE.DISCARD_TREASURE:
		discard_pile_treasures.append(card)
	
	emit_signal("_on_update_decks")

func draw_treasure():
	var card = deck_treasures.pop_back()
	emit_signal("_on_update_decks")
	return card

func shuffle_deck(type: DECK_TYPE):
	if type == DECK_TYPE.DRAW_DOOR:
		deck_doors.shuffle()
	elif type == DECK_TYPE.DRAW_TREASURE:
		deck_treasures.shuffle()
	elif type == DECK_TYPE.DISCARD_DOOR:
		deck_doors.append_array(discard_pile_doors)
		discard_pile_doors.clear()
		deck_doors.shuffle()
	elif type == DECK_TYPE.DISCARD_TREASURE:
		deck_treasures.append_array(discard_pile_treasures)
		discard_pile_treasures.clear()
		deck_treasures.shuffle()
	emit_signal("_on_update_decks")
	
func get_deck(type: DECK_TYPE):
	if type == DECK_TYPE.DRAW_DOOR:
		return deck_doors
	elif type == DECK_TYPE.DRAW_TREASURE:
		return deck_treasures
	elif type == DECK_TYPE.DISCARD_DOOR:
		return discard_pile_doors
	elif type == DECK_TYPE.DISCARD_TREASURE:
		return discard_pile_treasures


######################### UTILS ###################################
	
func fill_deck(deck: Array[int], amount: int):
	for i in range(1, amount):
		deck.append(i)
