extends Node

signal _on_update_players(players: Dictionary)

var players: Dictionary = {}
var playersPositions: Array[int] = []
var myPosition: int
var sitOffset = 0

func add_player(player: Dictionary):
	players[player.peer_id] = player
	if playersPositions.find(player.peer_id) == -1:
		playersPositions.append(player.peer_id)
	emit_signal("_on_update_players", players)


func update_players(players: Dictionary):
	self.players =  players
	emit_signal("_on_update_players", players)

func serialize():
	return {
		"players": players,
		"playersPositions": playersPositions
	}
	
func deserialize(data: Dictionary):
	self.players = data['players']
	var newPositions = data['playersPositions']
	#self.playersPositions = _reorderPosition(newPositions)
	self.playersPositions = newPositions
	
	var ownPeerId = NetworkManager.multiplayer.get_unique_id()
	if ownPeerId == 0:
		ownPeerId = 1
	myPosition = newPositions.find(ownPeerId)
	emit_signal("_on_update_players", players)

#func _reorderPosition(positions: Array[int]):
	#var peerId = NetworkManager.multiplayer.get_unique_id()
	#var needReorder = true
	#while needReorder:
		#if positions[0] == peerId:
			#needReorder = false
			#pass
		#else:
			#var x = positions.pop_front()
			#positions.push_back(x)
	#return positions

func change_position(peerId: int, newPosition: int):
	var oldIndex = playersPositions.find(peerId)
	var aux = playersPositions[newPosition]
	var newPlayerPositions = playersPositions.duplicate()
	newPlayerPositions[newPosition] = peerId
	newPlayerPositions[oldIndex] = aux
	myPosition = newPosition
	#self.playersPositions = _reorderPosition(newPlayerPositions)
	self.playersPositions = newPlayerPositions
