extends Node

signal _on_update_players(players: Dictionary)

#var CARD_TREASURE_SCENE = load("res://Scenes/CardTreasure.tscn")
var mouseOnHand: bool
var cardSelected: bool

var players: Dictionary = {}


func add_player(player: Dictionary):
	players[player.peer_id] = player
	emit_signal("_on_update_players", players)

func update_players(players: Dictionary):
	self.players =  players
	emit_signal("_on_update_players", players)
