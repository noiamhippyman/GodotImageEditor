extends Reference
class_name Project
var viewport:Viewport

func add_layer():
	var layer:Layer = Layer.new()
	viewport.add_child(layer)
	return layer

func get_layer(index:int):
	if (index < 0 or index >= viewport.get_child_count()):
		return
	return viewport.get_child(index)

func delete_layer(index:int):
	var layer:Layer = get_layer(index)
	layer.queue_free()

func set_name(name:String):
	viewport.name = name
func get_name():
	return viewport.name

func set_image_size(size:Vector2):
	viewport.size = size.round()
func get_image_size():
	return viewport.size

func update():
	viewport.set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
	viewport.set_update_mode(Viewport.UPDATE_ONCE)

func _init(name:String="Untitled Project",size:Vector2=Vector2(512,512)):
	viewport = Viewport.new()
	viewport.set_clear_mode(Viewport.CLEAR_MODE_NEVER)
	viewport.set_update_mode(Viewport.UPDATE_DISABLED)
	set_name(name)
	set_image_size(size)