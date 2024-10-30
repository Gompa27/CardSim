extends Control

@onready var port = %PortText
@onready var ip_address = %IpAddressText
@onready var username = %UsernameText

func _ready():
	NetworkManager.on_connection_failed.connect(_reset_buttons)

func _reset_buttons():
	%JoinButton.disabled = false
	%HostButton.disabled = false


func _on_join_button_pressed():
	%JoinButton.disabled = true
	%HostButton.disabled = true
	NetworkManager.connect_server(ip_address.text, int(port.text), username.text )

func _on_host_button_pressed():
	%JoinButton.disabled = true
	%HostButton.disabled = true
	NetworkManager.host_server(int(port.text))
	NetworkManager.rpc_login(username.text)
	
