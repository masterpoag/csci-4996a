extends Node

const NetworkPlayer = preload("res://scenes/basic_player.tscn")

func _process(delta: float) -> void:
	NetworkHandler.on_peer_connection.connect(spawn_player)
	ClientNetworkGlobal.handle_local_id_assignment.connect(spawn_player)
	ClientNetworkGlobal.handle_remote_id_assignment.connect(spawn_player)


func spawn_player(id: int) -> void:
	print("on_peer_connection ran")
	var player = NetworkPlayer.instantiate()
	print("adding player")
	player.owner_id = id
	player.name = str(id)
	call_deferred("add_child",player)
