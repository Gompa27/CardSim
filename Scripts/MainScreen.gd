extends Node

@export var pile_doors: Pile
@export var pile_treasures: Pile
@export var pile_discard_doors: Pile
@export var pile_discard_treasures: Pile
@export var pilePreview: PilePreview
@export var cardBaseScene: PackedScene


var soundsDic: Dictionary = {}
var soundsTurn: Array[AudioStreamPlayer2D] = []

func _ready():
	randomize()
	loadSoundsCards()
	loadSoundsTurns()
	var expansion = ExpansionsManager.getExpansion(Game.currentExpansion|| 0)

	_create_cards(expansion.decks[0].amount, cardBaseScene, pile_doors, Util.CARD_TYPE.DOOR, expansion.decks[0].resource)
	_create_cards(expansion.decks[1].amount, cardBaseScene, pile_treasures, Util.CARD_TYPE.TREASURE, expansion.decks[1].resource)
	Game.connect("on_open_popup", open_popup)
	Game.connect("on_close_popup", close_popup)
	Game.connect("on_end_turn", on_end_turn)

func _create_cards(amount: int, scene: PackedScene, newParent: Control, cardType: Util.CARD_TYPE, spriteFramesCard: String):
	var spriteFrames = load(spriteFramesCard)
	for cardNumber in range(1, amount):
		var card: Card = scene.instantiate()
		card.setSpritesFrames(spriteFrames)
		card.cardNumber = cardNumber
		card.isFaceDown = newParent.get_meta('face_down')
		var sound = soundsDic.get(str(cardNumber)+"_"+str(cardType))
		if sound:
			card.soundOnFlip = sound
		card.visible = true
		card.z_index = 50
		card.cardType = cardType
		card.connect('mouse_entered', show_preview.bind(card))
		card.connect('mouse_exited', hide_preview)
		newParent.add_child(card)
		
func _on_shuffle_menu_id_pressed(id):
	if id in [0,1,2,3]:
		NetworkManager.shuffle_deck(id)
	if id == 6: # Ver descarte puertas
		pilePreview.pile = pile_discard_doors
		pilePreview.popup()	
	if id == 7: # Ver descarte treasures
		pilePreview.pile = pile_discard_treasures
		pilePreview.popup()
		


func _process(_delta):
	var i = 0
	for playerNameLabel in get_tree().get_nodes_in_group('playerName'):
		if i < Game.playersPositions.size():
			playerNameLabel.text = Game.players[Game.playersPositions[i]].username
		else:
			playerNameLabel.text = 'Lugar vacio'
		i += 1


func _on_sit_button_1_pressed():
	NetworkManager.change_seat(0)


func _on_sit_button_2_pressed():
	if (Game.playersPositions.size() >= 2):
		NetworkManager.change_seat(1)


func _on_sit_button_3_pressed():
	if (Game.playersPositions.size() >= 3):
		NetworkManager.change_seat(2)

func _on_sit_button_4_pressed():
	if (Game.playersPositions.size() >= 4):
		NetworkManager.change_seat(3)


func _on_sit_button_5_pressed():
	if (Game.playersPositions.size() >= 5):
		NetworkManager.change_seat(4)

func _on_sit_button_6_pressed():
	if (Game.playersPositions.size() >= 6):
		NetworkManager.change_seat(5)
		
func close_popup():
	%Popup.hide()
	
func open_popup(texto: String):
	%Popup.get_child(0).text = texto
	%Popup.popup()
	

func show_preview(card: Card):
	if !card.isFaceDown:
		var sprite = card.get_child(0) as AnimatedSprite2D
		var newSprite = %PreviewCard.get_child(0) as AnimatedSprite2D
		newSprite.sprite_frames = sprite.sprite_frames
		newSprite.frame = sprite.frame
		
		var mousePosX = %PreviewCard.get_global_mouse_position().x
		var comparedWith = get_viewport().get_visible_rect().size.x / 2
		if mousePosX < comparedWith:
			%PreviewCard.set_anchors_and_offsets_preset(Control.PRESET_CENTER_RIGHT, Control.PRESET_MODE_KEEP_WIDTH)
		else:
			%PreviewCard.set_anchors_and_offsets_preset(Control.PRESET_CENTER_LEFT, Control.PRESET_MODE_KEEP_WIDTH)
		
		%PreviewCard.z_index = 200
		%PreviewCard.visible = true
	

func hide_preview():
	%PreviewCard.visible = false
	

func _on_deck_shuffle():
	$ShuffleDeck.play()


func loadSoundsCards():
	var duck = ResourceLoader.load("res://Assets/sounds/cards/duck.mp3") as AudioStream
	var chicken =ResourceLoader.load("res://Assets/sounds/cards/chicken.mp3") as AudioStream
	var cleric =ResourceLoader.load("res://Assets/sounds/cards/cleric.mp3") as AudioStream
	var elf =ResourceLoader.load("res://Assets/sounds/cards/elf.mp3") as AudioStream
	var hobbit =ResourceLoader.load("res://Assets/sounds/cards/hobbit.mp3") as AudioStream
	var dwarf =ResourceLoader.load("res://Assets/sounds/cards/dwarf.mp3") as AudioStream
	var oppsie =ResourceLoader.load("res://Assets/sounds/cards/oopsie.mp3") as AudioStream
	var myPrecious =ResourceLoader.load("res://Assets/sounds/cards/my-precious.mp3") as AudioStream
	var powerUp =ResourceLoader.load("res://Assets/sounds/cards/power_up.mp3") as AudioStream

	var audioPlayerDuck =AudioStreamPlayer2D.new()
	var audioPlayerChicken =AudioStreamPlayer2D.new()
	var audioPlayerCleric =AudioStreamPlayer2D.new()
	var audioPlayerElf =AudioStreamPlayer2D.new()
	var audioPlayerHobbit =AudioStreamPlayer2D.new()
	var audioPlayerDwarf =AudioStreamPlayer2D.new()
	var audioPlayerOppsie =AudioStreamPlayer2D.new()
	var audioPlayerMyPrecious =AudioStreamPlayer2D.new()
	var audioPlayerPowerUp =AudioStreamPlayer2D.new()


	audioPlayerDuck.stream =duck
	audioPlayerChicken.stream =chicken
	audioPlayerChicken.volume_db =5
	audioPlayerCleric.stream =cleric

	audioPlayerElf.stream =elf
	audioPlayerElf.volume_db = 10

	audioPlayerHobbit.stream =hobbit
	audioPlayerDwarf.stream =dwarf
	audioPlayerOppsie.stream =oppsie
	audioPlayerOppsie.volume_db = 10
	audioPlayerMyPrecious.stream =myPrecious
	audioPlayerMyPrecious.volume_db =10
	audioPlayerPowerUp.stream =powerUp
	
	
	self.add_child(audioPlayerDuck)
	self.add_child(audioPlayerChicken)
	self.add_child(audioPlayerCleric)
	self.add_child(audioPlayerElf)
	self.add_child(audioPlayerHobbit)
	self.add_child(audioPlayerDwarf)
	self.add_child(audioPlayerOppsie)
	self.add_child(audioPlayerMyPrecious)
	self.add_child(audioPlayerPowerUp)
	
	
	
	
	soundsDic["94_"+str(Util.CARD_TYPE.DOOR)] = audioPlayerDuck
	soundsDic["65_"+str(Util.CARD_TYPE.DOOR)] = audioPlayerChicken
	soundsDic["90_"+str(Util.CARD_TYPE.DOOR)] = audioPlayerChicken
	soundsDic["79_"+str(Util.CARD_TYPE.DOOR)] = audioPlayerOppsie
	soundsDic["44_"+str(Util.CARD_TYPE.TREASURE)] = audioPlayerMyPrecious
	soundsDic["6_"+str(Util.CARD_TYPE.DOOR)] = audioPlayerCleric
	soundsDic["35_"+str(Util.CARD_TYPE.DOOR)] = audioPlayerCleric
	soundsDic["40_"+str(Util.CARD_TYPE.DOOR)] = audioPlayerCleric
	soundsDic["20_"+str(Util.CARD_TYPE.DOOR)] = audioPlayerElf
	soundsDic["30_"+str(Util.CARD_TYPE.DOOR)] = audioPlayerElf
	soundsDic["75_"+str(Util.CARD_TYPE.DOOR)] = audioPlayerElf
	soundsDic["55_"+str(Util.CARD_TYPE.DOOR)] = audioPlayerHobbit
	soundsDic["61_"+str(Util.CARD_TYPE.DOOR)] = audioPlayerHobbit
	soundsDic["12_"+str(Util.CARD_TYPE.DOOR)] = audioPlayerHobbit
	soundsDic["14_"+str(Util.CARD_TYPE.DOOR)] = audioPlayerDwarf
	soundsDic["37_"+str(Util.CARD_TYPE.DOOR)] = audioPlayerDwarf
	soundsDic["56_"+str(Util.CARD_TYPE.DOOR)] = audioPlayerDwarf
	soundsDic["1_"+str(Util.CARD_TYPE.TREASURE)] = audioPlayerPowerUp
	soundsDic["3_"+str(Util.CARD_TYPE.TREASURE)] = audioPlayerPowerUp
	soundsDic["7_"+str(Util.CARD_TYPE.TREASURE)] = audioPlayerPowerUp
	soundsDic["12_"+str(Util.CARD_TYPE.TREASURE)] = audioPlayerPowerUp
	soundsDic["15_"+str(Util.CARD_TYPE.TREASURE)] = audioPlayerPowerUp
	soundsDic["16_"+str(Util.CARD_TYPE.TREASURE)] = audioPlayerPowerUp
	soundsDic["22_"+str(Util.CARD_TYPE.TREASURE)] = audioPlayerPowerUp
	soundsDic["38_"+str(Util.CARD_TYPE.TREASURE)] = audioPlayerPowerUp
	soundsDic["41_"+str(Util.CARD_TYPE.TREASURE)] = audioPlayerPowerUp
	soundsDic["71_"+str(Util.CARD_TYPE.TREASURE)] = audioPlayerPowerUp
	
func loadSoundsTurns():
	for i in range(1, 6):
		var resource = "res://Assets/sounds/turns/turn"+str(i)+".mp3"
		var audioStream = ResourceLoader.load(resource) as AudioStream
		var audioPlayerTurn = AudioStreamPlayer2D.new()
		audioPlayerTurn.stream = audioStream
		self.add_child(audioPlayerTurn)	
		soundsTurn.append(audioPlayerTurn)

func on_end_turn(sound: int):
	soundsTurn[sound].play()
