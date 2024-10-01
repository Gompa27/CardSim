extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	Game.connect("_on_update_players", update_list)
	update_list(Game.players)

func update_list(players: Dictionary):
	var children = self.get_children()
	for child in children:
		child.queue_free()
	
	for player in players.values():
		var label = Label.new()
		label.text = player["username"]
		self.add_child(label)
