extends Control

const Project = preload("res://Classes/Project.gd")

var current_project:Project setget set_current_project,get_current_project
func set_current_project(project:Project):
	current_project = project
func get_current_project():
	return current_project

func new_project(project_name:String,image_size:Vector2):
	return Project.new(project_name,image_size)


func _ready():
	OS.set_low_processor_usage_mode(true)
	$VBoxContainer/HBoxContainer/ImageViewport/ImageBorder.set_visible(false)
	
#	$VBoxContainer/HBoxContainer/ImageViewport/TextureRect.set_texture($Viewport.get_texture())
#	$Viewport.set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)

#func _process(delta):
#	if (Input.is_mouse_button_pressed(BUTTON_LEFT)):
#		var img = $VBoxContainer/HBoxContainer/ImageViewport/TextureRect
#		use_tool(img.get_local_mouse_position())
#
#func use_tool(pos:Vector2):
#	$Viewport/Brush.position = pos
#	$Viewport.set_update_mode(Viewport.UPDATE_ONCE)

func close_application():
	get_tree().quit()

func _on_MenuBar_file_quit():
	close_application()

func _on_MenuBar_file_new():
	var project:Project = new_project("Test Project",Vector2(640,480))
	set_current_project(project)
	$VBoxContainer/HBoxContainer/ImageViewport/ImageBorder.set_visible(true)
	
	# Update ViewportTexture
	$VBoxContainer/HBoxContainer/ImageViewport/TextureRect.set_texture(project.viewport.get_texture())
