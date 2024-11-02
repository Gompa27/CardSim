extends Node

enum EXPANSIONS {
	NORMAL,
	SECOND
}


var expansions: Dictionary = {}

func _init():
	expansions[EXPANSIONS.NORMAL] = {
		'name': 'Normal',
		'decks': [{
			'amount': 95,
			'resource': "res://Resources/doors.tres"
		},{
			'amount': 72,
			'resource': "res://Resources/treasures.tres"
		}]
	}
	
	expansions[EXPANSIONS.SECOND] = {
		'name': 'Segunda - Hacha descomunal',
		'decks': [{
			'amount': 64,
			'resource': "res://Resources/doors2.tres"
		},{
			'amount': 72,
			'resource': "res://Resources/treasures.tres"
		}]
	}
	

func getExpansion(number: int):
	return self.expansions[number]
