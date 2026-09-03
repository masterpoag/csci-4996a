extends Control


func _on_server_pressed() -> void:
	NetworkHandler.start_server()
	#get_tree().change_scene_to_file("res://server.tscn")


func _on_client_pressed() -> void:
	NetworkHandler.start_client()
	#get_tree().change_scene_to_file("res://client.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
