extends Node

# Server Vars
var available_peer_ids: Array = range(255,-1,-1)
var client_peers: Dictionary[int, ENetPacketPeer]

# Client Vars
var server_peer: ENetPacketPeer

# Vars
var connection: ENetConnection
var is_server: bool = false

# Server side - signals
signal on_peer_connection(peer_id: int)
signal on_peer_disconnected(peer_id: int)
signal on_server_packet(peer_id: int, data: PackedByteArray)


# Client side - signals
signal on_connected_to_server()
signal on_disconnected_from_server()
signal on_client_packet(data: PackedByteArray)


# Server Func
func start_server(ip_address: String = "127.0.0.1", port: int = 42523) -> void:
	connection = ENetConnection.new()
	var error: Error = connection.create_host_bound(ip_address,port)
	if error:
		print("Server Failed to start: ", error_string(error))
	print("Server Started On: ",ip_address,":",port)

func peer_connected(peer: ENetPacketPeer) -> void:
	var peer_id: int = available_peer_ids.pop_back()
	peer.set_meta("id", peer_id)
	client_peers[peer_id] = peer
	print("Peer with ID: ",peer_id," Has connected")
	on_peer_connection.emit(peer_id)

func peer_disconnect(peer: ENetPacketPeer) -> void:
	var peer_id: int = peer.get_meta("id")
	available_peer_ids.push_back(peer_id)
	client_peers.erase(peer_id)
	print("Peer with ID: ",peer_id," Has Disconnected")
	on_peer_disconnected.emit(peer_id)


# Client Func
func start_client(ip_address: String = "127.0.0.1", port: int = 42523) -> void:
	connection = ENetConnection.new()
	var error: Error = connection.create_host(1)
	if error:
		print("Client Failed to join: ", error_string(error))
		connection = null
		return
	print("Connected To: ",ip_address,":",port)
	is_server = true

func connected_to_server() -> void:
	print("Connected to Server")
	on_connected_to_server.emit()

func disconnected_from_server() -> void:
	print("Disconnected From Server")
	on_disconnected_from_server.emit()
	connection = null

func disconnect_client() -> void:
	if is_server:
		return
	server_peer.peer_disconnect()

# Event Handler
func handle_events() -> void:
	var packet_event: Array = connection.service()
	var event_type: ENetConnection.EventType = packet_event[0]
	
	while event_type != ENetConnection.EVENT_NONE:
		var peer: ENetPacketPeer = packet_event[1]
		
		match event_type:
			ENetConnection.EVENT_CONNECT:
				if is_server:
					peer_connected(peer)
				else:
					connected_to_server()
			ENetConnection.EVENT_ERROR:
				push_warning("Unknown error in packet")
				return
			ENetConnection.EVENT_DISCONNECT:
				if is_server:
					peer_disconnect(peer)
				else:
					disconnected_from_server()
					return 
			ENetConnection.EVENT_RECEIVE:
				if is_server:
					on_server_packet.emit(peer.get_meta("id"), peer.get_packet())
				else:
					on_client_packet.emit(peer.get_packet())
		packet_event = connection.service()
		event_type = packet_event[0]



# Logic Loop
func _process(delta: float) -> void:
	if connection == null: 
		return
	handle_events()
	
