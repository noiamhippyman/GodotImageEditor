extends Control

func _ready():
	OS.set_low_processor_usage_mode(true)
	$VBoxContainer/HBoxContainer/ImageViewport/TextureRect.set_texture($Viewport.get_texture())
	$Viewport.set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)

func _process(delta):
	if (Input.is_action_pressed("ui_accept")):
		var img = $VBoxContainer/HBoxContainer/ImageViewport/TextureRect
		$Viewport/Node2D.position = img.get_local_mouse_position()
		$Viewport.set_update_mode(Viewport.UPDATE_ONCE)

func close_application():
	get_tree().quit()

func _on_MenuBar_file_quit():
	close_application()