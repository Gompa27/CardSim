extends Node

signal _on_update_players(players: Dictionary)
signal _on_update_decks()

const DOORS_CARDS = 95
const TREASURE_CARDS = 73

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



func draw_door():
	var card = deck_doors.pop_back()
	print("DRAW DOOR")
	emit_signal("_on_update_decks")
	return card
	
	
func discard_door(card: int):
	discard_pile_doors.append(card)
	emit_signal("_on_update_decks")

func draw_treasure():
	var card = deck_treasures.pop_back()
	emit_signal("_on_update_decks")
	return card

func discard_treasure(card: int):
	discard_pile_treasures.append(card)
	emit_signal("_on_update_decks")




######################### UTILS ###################################
	
func fill_deck(deck: Array[int], amount: int):
	for i in range(1, amount):
		deck.append(i)
