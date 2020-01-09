extends Control

var image_position:Vector2 setget set_image_pos,get_image_pos
func set_image_pos(pos:Vector2):
	image_position = pos
	update()
func get_image_pos():
	return image_position

var image_zoom:float setget set_image_zoom,get_image_zoom
func set_image_zoom(zoom:float):
	image_zoom = zoom
	update()
func get_image_zoom():
	return image_zoom

func _draw():
	draw_rect(Rect2(get_image_pos(),(get_parent().get_node("TextureRect").rect_size) * get_image_zoom()),Color.yellow,false)