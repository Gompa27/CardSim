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
	PLAYER_HAND
}




func calculate_position_for_user(position: Vector2, playerPos: int):
	match playerPos:
		0:
			return position
		1:
			return position
		2:
			return Vector2(position.x, -1*position.y)
		3:
			return position
		_:
			return position
	
	
	
