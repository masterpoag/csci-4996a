class_name PositionPacket extends PacketInfo

var id: int
var pos: Vector2 # This is the data that needs to get encoded and sent

static func create (id: int, data: Vector2) -> PositionPacket:
	var info: PositionPacket = PositionPacket.new()
	info.packet_type = PACKET_TYPE.POSITION
	info.flag = ENetPacketPeer.FLAG_RELIABLE # TCP like
#	info.flag = ENetPacketPeer.FLAG_UNSEQUENCED # UDP like
	info.id = id
	info.pos = data
	return info

static func create_from_data(data: PackedByteArray) -> PositionPacket:
	var info: PositionPacket = PositionPacket.new()
	info.decode(data)
	return info

func encode() -> PackedByteArray:
	var data: PackedByteArray = super.encode()
	data.resize(10) # Max size of packet look at encode_[type] for more info
	data.encode_u8(1,id) # encodes packet id
	data.encode_float(2,pos.x) # encode based off data you are sending in packet
	data.encode_float(6,pos.y) # encode based off data you are sending in packet
	return data

func decode(data: PackedByteArray) -> void:
	super.decode(data)
	id = data.decode_u8(1)
	pos = Vector2(data.decode_float(2),data.decode_float(6))