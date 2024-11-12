extends Node2D

const PORT = 4433

func start_game():
	for child in get_children():
		if child.name == "MultiplayerSpawner": continue
		
		child.visible = false
	
	for node in preload("res://Scenes/Levels/Level_01.tscn").instantiate().get_children():
		node.reparent(self)

	if multiplayer.is_server():
		_on_connected.rpc()
	else:
		multiplayer.peer_connected.connect(_on_connected.rpc)

@rpc("call_local")
func _on_connected():
	print("aaa")
	var players = multiplayer.get_peers()
	
	add_player(multiplayer.get_unique_id())
	for peer in players:
		add_player(peer)

func _exit_tree():
	if not multiplayer.is_server():
		return
	multiplayer.peer_connected.disconnect(add_player)
	multiplayer.peer_disconnected.disconnect(del_player)

func add_player(id: int):
	var character = preload("res://Scenes/Prefabs/player.tscn").instantiate()

	character.player = id

	character.global_position = Vector2(174, -100)
	character.name = str(id)
	add_child(character, true)

func del_player(id: int):
	if not has_node(str(id)):
		return
	get_node(str(id)).queue_free()

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


func _on_button_pressedewf() -> void:
	_on_button_pressed()


func _on_button_2_pressedZCS() -> void:
	_on_connect_pressed()
