extends Node
const AMOUNT_DOORS_CARDS = 95
const AMOUNT_TREASURE_CARDS = 73

enum CARD_TYPE {
	DOOR,
	TREASURE
}

enum PILE_TYPE {
	DOOR,
	TREASURE,
	DISCARD_DOOR,
	DISCARD_TREASURE,
	TABLE,
	TABLE_PLAYER_1,
	TABLE_PLAYER_2,
	TABLE_PLAYER_3,
	TABLE_PLAYER_4,
	PLAYER_HAND_1,
	PLAYER_HAND_2,
	PLAYER_HAND_3,
	PLAYER_HAND_4
}

const PILE_TABLE_PLAYER = [
	PILE_TYPE.TABLE_PLAYER_1,
	PILE_TYPE.TABLE_PLAYER_2,
	PILE_TYPE.TABLE_PLAYER_3,
	PILE_TYPE.TABLE_PLAYER_4
]

const PILE_ALL_TABLES = [
	PILE_TYPE.TABLE,
	PILE_TYPE.TABLE_PLAYER_1,
	PILE_TYPE.TABLE_PLAYER_2,
	PILE_TYPE.TABLE_PLAYER_3,
	PILE_TYPE.TABLE_PLAYER_4
]

const PILE_HAND_PLAYER = [
	PILE_TYPE.PLAYER_HAND_1,
	PILE_TYPE.PLAYER_HAND_2,
	PILE_TYPE.PLAYER_HAND_3,
	PILE_TYPE.PLAYER_HAND_4
]


func calculate_position_for_user(card: Control, position: Vector2, playerPos: int):
	return position
	#var screenSize = get_viewport().get_visible_rect().size
	#var ratioScreen = screenSize.x / screenSize.y
	#var posX = position.x
	#var posY = position.y
	#print('PLAYER_POS', playerPos)
	#match playerPos:
		#0:
			#return position
		#1:
			#return Vector2(posY * ratioScreen , (screenSize.x - posX) / ratioScreen)
		#2:
			#return Vector2(posX + card.size.x, screenSize.y - posY)
		#3:
			##return Vector2(posX * ratioScreen, posY / ratioScreen)
			#return position
		#_:
			#return position

func calculate_rotation_for_user(playerPos: int):
	match playerPos:
		0:
			return 0
		1:
			return 270
		2:
			return 180
		3:
			return 90
		_:
			return 0
