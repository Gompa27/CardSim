extends Control

@onready var port = %PortText
@onready var ip_address = %IpAddressText
@onready var username = %UsernameText


func _on_join_button_pressed():
	NetworkManager.connect_server(ip_address.text, int(port.text), username.text )

func _on_host_button_pressed():
	NetworkManager.host_server(int(port.text))
	NetworkManager.rpc_login(username.text)
