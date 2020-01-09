extends Container

var drag_start_position:Vector2 setget set_drag_start_position,get_drag_start_position
func set_drag_start_position(start:Vector2):
	drag_start_position = start
func get_drag_start_position():
	return drag_start_position

var dragging:bool setget set_dragging,is_dragging
func set_dragging(enable:bool):
	dragging = enable
func is_dragging():
	return dragging

signal drag_offset_changed(offset)
var drag_offset:Vector2 setget set_drag_offset,get_drag_offset
func set_drag_offset(offset:Vector2):
	drag_offset = offset
	emit_signal("drag_offset_changed",drag_offset)
func get_drag_offset():
	return drag_offset

func wrap_dragging_mouse(mouse_position):
	get_viewport().warp_mouse(mouse_position)
	set_drag_start_position(mouse_position)

func process_dragging():
	if (is_dragging()):
		var mouse_position:Vector2 = get_global_mouse_position()
		var bounds:Rect2 = get_global_rect()
		var mouse_start_end_diff = get_drag_start_position() - mouse_position

		set_drag_offset(get_drag_offset() - mouse_start_end_diff)
		set_drag_start_position(mouse_position)
		
		if (mouse_position.x < bounds.position.x):
			mouse_position.x += bounds.size.x
			wrap_dragging_mouse(mouse_position)
		elif (mouse_position.x > bounds.position.x + bounds.size.x):
			mouse_position.x -= bounds.size.x
			wrap_dragging_mouse(mouse_position)
		
		if (mouse_position.y < bounds.position.y):
			mouse_position.y += bounds.size.y
			wrap_dragging_mouse(mouse_position)
		elif (mouse_position.y > bounds.position.y + bounds.size.y):
			mouse_position.y -= bounds.size.y
			wrap_dragging_mouse(mouse_position)

const MIN_ZOOM = 0.1
const MAX_ZOOM = 10.0
signal zoom_changed(zoom)
var zoom:float setget set_zoom,get_zoom
func set_zoom(val):
	zoom = clamp(val,MIN_ZOOM,MAX_ZOOM)
	emit_signal("zoom_changed", zoom)
func get_zoom():
	return zoom

func zoom_on_position(p_zoom:float,p_pos:Vector2):
	if (p_zoom < MIN_ZOOM || p_zoom > MAX_ZOOM):
		return
	
	var prev_zoom:float = get_zoom()
	set_zoom(p_zoom)
	var ofs:Vector2 = get_drag_offset() - p_pos
	ofs = (ofs / prev_zoom) - (ofs / get_zoom())
	set_drag_offset(Vector2(round(drag_offset.x + ofs.x),round(drag_offset.y + ofs.y)))

func _ready():
	set_zoom(1)
	set_dragging(false)
	set_drag_start_position(Vector2.ZERO)
	set_drag_offset(Vector2.ZERO)

func _process(delta):
	process_dragging()

func _on_ImageViewport_gui_input(event):
	if (event is InputEventMouseButton):
		
		# Dragging viewport with mouse
		if (event.button_index == BUTTON_MIDDLE and event.is_pressed()):
			set_dragging(true)
			set_drag_start_position(get_global_mouse_position())
		if (event.button_index == BUTTON_MIDDLE and !event.is_pressed()):
			set_dragging(false)
		
		# Zooming with mouse wheel
		if (event.button_index == BUTTON_WHEEL_DOWN):
			zoom_on_position(zoom * (1 - (0.05 * event.factor)),event.position)
		if (event.button_index == BUTTON_WHEEL_UP):
			zoom_on_position(zoom * ((0.95 + (0.05 * event.factor)) / 0.95),event.position)

func _on_ImageViewport_drag_offset_changed(offset):
	$TextureRect.rect_position = offset
	$ImageBorder.set_image_pos(offset)
	$Rulers.set_view_transform($TextureRect.get_transform())

func _on_ImageViewport_zoom_changed(zoom):
	$Rulers.set_zoom(zoom)
	$ImageBorder.set_image_zoom(zoom)
	$TextureRect.rect_scale = Vector2(zoom,zoom)

func _on_ImageViewport_resized():
	$Rulers.update()

func _on_TextureRect_resized():
	$ImageBorder.update()
