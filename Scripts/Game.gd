extends Node

signal _on_update_players(players: Dictionary)


var cardSelected
var mouseOnPlacement = false
var mouseOnHand = false


var players: Dictionary = {}


func add_player(player: Dictionary):
	players[player.peer_id] = player
	emit_signal("_on_update_players", players)



func update_players(players: Dictionary):
	self.players =  players
	emit_signal("_on_update_players", players)
