extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client("127.0.0.1", 8910)
	if error == OK:
		multiplayer.multiplayer_peer = peer
		print("Connecting to server...")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass 
