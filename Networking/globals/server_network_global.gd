extends Node

signal handle_player_position(peer_id: int, player_position: PositionPacket)

var peer_ids: Array[int]

func _ready() -> void:
	NetworkHandler.on_peer_connection.connect(on_peer_connected)
	NetworkHandler.on_peer_disconnected.connect(on_peer_disconnected)
	NetworkHandler.on_server_packet.connect(on_server_packet)

func on_peer_connected(peer_id: int) -> void:
	peer_ids.append(peer_id)
	var peer: ENetPacketPeer = NetworkHandler.client_peers[peer_id]
	IDAssignment.create(peer_id, peer_ids).send(peer)
	for other_peer_id in peer_ids:
		if other_peer_id == peer_id: continue
		IDAssignment.create(peer_id, []).send(NetworkHandler.client_peers[other_peer_id])

func on_peer_disconnected(peer_id: int) -> void:
	peer_ids.erase(peer_id)

func on_server_packet(peer_id: int, data: PackedByteArray) -> void:
	var packet_type: int = data.decode_u8(0)
	match packet_type:
		PacketInfo.PACKET_TYPE.POSITION:
			handle_player_position.emit(peer_id, PositionPacket.create_from_data(data))
		_:
			push_error("Packet type with index ", data[0]," unhandled!")
