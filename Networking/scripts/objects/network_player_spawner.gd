extends Node

const NetworkPlayer = preload("res://scenes/basic_player.tscn")

var pending_player_ids: Dictionary[int, bool] = {}

func _ready() -> void:
	NetworkHandler.on_peer_connection.connect(spawn_player)
	ClientNetworkGlobal.handle_local_id_assignment.connect(spawn_player)
	ClientNetworkGlobal.handle_remote_id_assignment.connect(spawn_player)


func spawn_player(id: int) -> void:
	var player_name := str(id)
	if has_node(player_name) || pending_player_ids.has(id):
		return
	pending_player_ids[id] = true
	var player = NetworkPlayer.instantiate()
	player.owner_id = id
	player.name = player_name
	add_child(player)
	pending_player_ids.erase(id)
