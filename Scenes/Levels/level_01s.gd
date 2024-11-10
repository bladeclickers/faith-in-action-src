extends Node2D

signal readyforpeerspawn

func _ready() -> void:
	_on_connected.rpc()

@rpc("call_local")
func _on_connected():
	var players = multiplayer.get_peers()
	
	if multiplayer.is_server():
		add_player(multiplayer.get_unique_id())
		for peer in players:
			add_player(peer)
			print(peer)
			readyforpeerspawn.emit()
	else:
		await readyforpeerspawn
		add_player(multiplayer.get_unique_id())
		for peer in players:
			add_player(peer)
			print(peer)

func _exit_tree():
	if not multiplayer.is_server():
		return
	multiplayer.peer_connected.disconnect(add_player)
	multiplayer.peer_disconnected.disconnect(del_player)

func add_player(id: int):
	var character = load("res://Scenes/Prefabs/player.tscn").instantiate()

	character.player = id

	character.global_position = Vector2(174, -100)
	character.name = str(id)
	add_child(character, true)

func del_player(id: int):
	if not has_node(str(id)):
		return
	get_node(str(id)).queue_free()
