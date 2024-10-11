extends Node

signal _on_update_players(players: Dictionary)
signal _on_open_popup(texto: String)
signal _on_close_popup()
signal _on_change_level(playerNumber: int, level: int)

var players: Dictionary = {}
var playersPositions: Array[int] = []
var playersPointers: Array[Vector2] = []
var myPosition: int
var sitOffset = 0
var currentPlayerTurn: int = 0

func add_player(player: Dictionary):
	players[player.peer_id] = player
	if playersPositions.find(player.peer_id) == -1:
		playersPositions.append(player.peer_id)
		playersPointers.append(Vector2(0,0))
	emit_signal("_on_update_players", players)
	
func update_pointer(peerId: int, position: Vector2):
	var playerIndex = playersPositions.find(peerId)
	if playerIndex >=0 :
		playersPointers[playerIndex] = position


func update_players(players: Dictionary):
	self.players =  players
	emit_signal("_on_update_players", players)

func serialize():
	return {
		"players": players,
		"playersPositions": playersPositions,
		"playersPointers": playersPointers
	}
	
func deserialize(data: Dictionary):
	self.players = data['players']
	self.playersPositions = data['playersPositions']
	self.playersPointers = data['playersPointers']
	
	var ownPeerId = NetworkManager.multiplayer.get_unique_id()
	if ownPeerId == 0:
		ownPeerId = 1
	myPosition = self.playersPositions.find(ownPeerId)
	emit_signal("_on_update_players", players)


func change_position(peerId: int, newPosition: int):
	var oldIndex = playersPositions.find(peerId)
	var aux = playersPositions[newPosition]
	var newPlayerPositions = playersPositions.duplicate()
	newPlayerPositions[newPosition] = peerId
	newPlayerPositions[oldIndex] = aux
	myPosition = newPosition
	#self.playersPositions = _reorderPosition(newPlayerPositions)
	self.playersPositions = newPlayerPositions

func openAlertViewDiscard(peerId: int):
	emit_signal("_on_open_popup", "{0} esta viendo la pila de descarte".format([players[peerId].username]))

func closePopup():
	emit_signal("_on_close_popup")
	
func change_level(playerNumber: int, level: int):
	emit_signal('_on_change_level', playerNumber, level)

func endTurn(peerId):
	var nextTurn = playersPositions.find(peerId) + 1
	if nextTurn > 3:
		nextTurn = 0
	currentPlayerTurn = nextTurn
	
