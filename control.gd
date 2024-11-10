extends Node2D

const PORT = 4433

func start_game():
	SceneTransition.load_scene("res://Scenes/Levels/Level_01.tscn")

func _ready():
	multiplayer.server_relay = false

	if DisplayServer.get_name() == "headless":
		print("Automatically starting dedicated server.")
		_on_host_pressed.call_deferred()

func _on_host_pressed():
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer server.")
		return
	multiplayer.multiplayer_peer = peer
	start_game()

func _on_connect_pressed():
	var txt : String = get_node("TextEdit").text
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(txt, PORT)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer client.")
		return
	multiplayer.multiplayer_peer = peer
	start_game()

func _on_button_pressed() -> void:
	_on_host_pressed()

func _on_button_2_pressed() -> void:
	_on_connect_pressed()
