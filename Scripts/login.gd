extends Control

@onready var port = %PortText
@onready var ip_address = %IpAddressText
@onready var username = %UsernameText

var expansionSelected: int = 0

func _ready():
	NetworkManager.connect("on_connection_failed", _reset_buttons)

func _reset_buttons():
	%JoinButton.disabled = false
	%HostButton.disabled = false


func _on_join_button_pressed():
	%JoinButton.disabled = true
	%HostButton.disabled = true
	Game.joinGame(ip_address.text, int(port.text), username.text)

func _on_host_button_pressed():
	%JoinButton.disabled = true
	%HostButton.disabled = true
	Game.hostGame(username.text, int(port.text), expansionSelected)

func _on_option_button_item_selected(index):
	expansionSelected = index
