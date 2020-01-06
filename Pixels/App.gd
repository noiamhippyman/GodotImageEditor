extends Control

func _ready():
	OS.set_low_processor_usage_mode(true)

func close_application():
	get_tree().quit()

func _on_MenuBar_file_quit():
	close_application()