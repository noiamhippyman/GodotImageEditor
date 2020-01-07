extends Container

var dragStartPos:Vector2 setget set_drag_start_pos,get_drag_start_pos
func set_drag_start_pos(start:Vector2):
	dragStartPos = start
func get_drag_start_pos():
	return dragStartPos

var dragging:bool setget set_dragging,is_dragging
func set_dragging(enable:bool):
	dragging = enable
func is_dragging():
	return dragging

signal drag_offset_changed(offset)
var dragOffset:Vector2 setget set_drag_offset,get_drag_offset
func set_drag_offset(offset:Vector2):
	dragOffset = offset
	emit_signal("drag_offset_changed",dragOffset)
func get_drag_offset():
	return dragOffset

const MIN_ZOOM = 0.1
const MAX_ZOOM = 10.0
signal zoom_changed(zoom)
var zoom:float setget set_zoom,get_zoom
func set_zoom(val):
	zoom = clamp(val,MIN_ZOOM,MAX_ZOOM)
	emit_signal("zoom_changed", zoom)
func get_zoom():
	return zoom

func wrap_dragging_mouse(mousePos):
	get_viewport().warp_mouse(mousePos)
	set_drag_start_pos(mousePos)

func process_dragging():
	if (is_dragging()):
		var mousePos:Vector2 = get_global_mouse_position()
		var bounds:Rect2 = get_global_rect()
		var mouseStartEndDiff = get_drag_start_pos() - mousePos

		set_drag_offset(get_drag_offset() - mouseStartEndDiff)
		set_drag_start_pos(mousePos)
		
		if (mousePos.x < bounds.position.x):
			mousePos.x += bounds.size.x
			wrap_dragging_mouse(mousePos)
		elif (mousePos.x > bounds.position.x + bounds.size.x):
			mousePos.x -= bounds.size.x
			wrap_dragging_mouse(mousePos)
		
		if (mousePos.y < bounds.position.y):
			mousePos.y += bounds.size.y
			wrap_dragging_mouse(mousePos)
		elif (mousePos.y > bounds.position.y + bounds.size.y):
			mousePos.y -= bounds.size.y
			wrap_dragging_mouse(mousePos)
		
		update()

func zoom_on_position(p_zoom:float,p_pos:Vector2):
	if (p_zoom < MIN_ZOOM || p_zoom > MAX_ZOOM):
		return
	
	var prevZoom:float = get_zoom()
	set_zoom(p_zoom)
	var ofs:Vector2 = get_drag_offset() - p_pos
	ofs = (ofs / prevZoom) - (ofs / get_zoom())
	set_drag_offset(Vector2(round(dragOffset.x + ofs.x),round(dragOffset.y + ofs.y)))

func _ready():
	set_zoom(1)
	set_dragging(false)
	set_drag_start_pos(Vector2.ZERO)
	set_drag_offset(Vector2.ZERO)

func _process(delta):
	process_dragging()

func _on_ImageViewport_gui_input(event):
	if (event is InputEventMouseButton):
		
		# Dragging viewport with mouse
		if (event.button_index == BUTTON_MIDDLE and event.is_pressed()):
			set_dragging(true)
			set_drag_start_pos(get_global_mouse_position())
		if (event.button_index == BUTTON_MIDDLE and !event.is_pressed()):
			set_dragging(false)
		
		# Zooming with mouse wheel
		if (event.button_index == BUTTON_WHEEL_DOWN):
			zoom_on_position(zoom * (1 - (0.05 * event.factor)),event.position)
		if (event.button_index == BUTTON_WHEEL_UP):
			zoom_on_position(zoom * ((0.95 + (0.05 * event.factor)) / 0.95),event.position)

func _on_ImageViewport_drag_offset_changed(offset):
	$TextureRect.rect_position = offset
	$Rulers.set_view_transform($TextureRect.get_transform())

func _on_ImageViewport_zoom_changed(zoom):
	$Rulers.set_zoom(zoom)
	$TextureRect.rect_scale = Vector2(zoom,zoom)
	update()


func _on_ImageViewport_resized():
	$Rulers.update()
