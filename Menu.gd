extends Control


func _on_server_pressed() -> void:
	self.hide()
	NetworkHandler.start_server()


func _on_client_pressed() -> void:
	NetworkHandler.start_client()
	self.hide()

func _on_quit_pressed() -> void:
	get_tree().quit()
