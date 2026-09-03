extends CharacterBody2D

const SPEED: float = 500.0

var is_authority: bool:
	get: return !NetworkHandler.is_server && owner_id == ClientNetworkGlobal.id

var owner_id

func _enter_tree() -> void:
	ServerNetworkGlobal.handle_player_position.connect(server_handle_player_position)
	ClientNetworkGlobal.handle_player_position.connect(client_handle_player_position)

func _exit_tree() -> void:
	ServerNetworkGlobal.handle_player_position.disconnect(server_handle_player_position)
	ClientNetworkGlobal.handle_player_position.disconnect(client_handle_player_position)
	
func _physics_process(delta: float) -> void:
	if !is_authority: return
	velocity = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	move_and_slide()
	PacketBase.create(owner_id, global_position).send(NetworkHandler.server_peer)

func server_handle_player_position(peer_id: int, player_position: PacketBase) -> void:
	if owner_id != peer_id: return
	global_position = player_position.pos
	PacketBase.create(owner_id,global_position).broadcast(NetworkHandler.connection)

func client_handle_player_position(player_postition: PacketBase) -> void:
	if is_authority || owner_id != player_postition.id: return
	
	global_position = player_postition.pos
