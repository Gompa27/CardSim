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
			'amount': 159,
			'resource': "res://Resources/doors2.tres"
		},{
			'amount': 116,
			'resource': "res://Resources/treasures2.tres"
		}]
	}
	

func getExpansion(number: int):
	return self.expansions[number]
