class_name PacketBase extends PacketInfo
# all PacketBase need to get replaced with what the packet is

var id: int
var pos: Vector2 # This is the data that needs to get encoded and sent

static func create (id: int, data: Vector2) -> PacketBase:
	var info: PacketBase = PacketBase.new()
	info.packet_type = PACKET_TYPE.TEMP #ENUM from res://Networking/scripts/packets/packet_info.gd
	info.flag = ENetPacketPeer.FLAG_RELIABLE # TCP like
#	info.flag = ENetPacketPeer.FLAG_UNSEQUENCED # UDP like
	info.id = id
	info.temp = data 
	return info

static func create_from_data(data: PackedByteArray) -> PacketBase:
	var info: PacketBase = PacketBase.new()
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
	id = data.decode_double(1)
	pos = Vector2(data.decode_float(2),data.decode_float(6))
