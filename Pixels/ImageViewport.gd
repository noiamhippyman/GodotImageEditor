extends Container
onready var textureRect = $TextureRect
var dragStart:Vector2 setget set_drag_start,get_drag_start
func set_drag_start(start:Vector2):
	dragStart = start
func get_drag_start():
	return dragStart

var dragging:bool setget set_dragging,is_dragging
func set_dragging(enable:bool):
	dragging = enable
func is_dragging():
	return dragging

var zoomMultiplier:float = 0.01
onready var zoom:float = 1.0
const MIN_ZOOM = 0.1
const MAX_ZOOM = 10.0

func wrap_dragging_mouse(mousePos):
	get_viewport().warp_mouse(mousePos)
	set_drag_start(mousePos)

func process_dragging():
	if (is_dragging()):
		var mousePos:Vector2 = get_global_mouse_position()
		var bounds:Rect2 = get_global_rect()
		var mouseStartEndDiff = get_drag_start() - mousePos

		textureRect.set_position(textureRect.get_position() - mouseStartEndDiff)
		set_drag_start(mousePos)
		
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

func _process(delta):
	process_dragging()

func draw_ruler_guides():
	var zero = Vector2.ZERO
	var size = $".".get_rect().size
	var font = get_font("rulers","EditorFonts")
	var rulerSize = 24
	var major_subdivision:int = 2
	var minor_subdivision:int = 5
	var my_transform = textureRect.get_transform()
	var ruler_transform:Transform2D = Transform2D()
	var RULE = 50
	var basic_rule:float = RULE
	var i:int = 0
	while (basic_rule * zoom > RULE):
		basic_rule /= float(minor_subdivision) if (i % 2) else float(major_subdivision)
		i += 1
	i = 0
	while (basic_rule * zoom < RULE):
		basic_rule *= float(major_subdivision) if (i % 2) else float(minor_subdivision)
		i += 1
	ruler_transform = ruler_transform.scaled(Vector2(basic_rule,basic_rule))

	var major_subdivide:Transform2D = Transform2D()
	major_subdivide = major_subdivide.scaled(Vector2(1.0 / major_subdivision, 1.0 / major_subdivision))
		
	var minor_subdivide:Transform2D = Transform2D()
	minor_subdivide = minor_subdivide.scaled(Vector2(1.0 / minor_subdivision, 1.0 / minor_subdivision))
	
	var first:Vector2 = (my_transform * ruler_transform * major_subdivide * minor_subdivide).affine_inverse().xform(Vector2(rulerSize,rulerSize))
	var last:Vector2 = (my_transform * ruler_transform * major_subdivide * minor_subdivide).affine_inverse().xform(size)
	
	# draw top ruler
	draw_rect(Rect2(Vector2(rulerSize,0),Vector2(size.x,rulerSize)),Color.blue)
	for i in range(ceil(first.x),last.x,1):
		var pos:Vector2 = (my_transform * ruler_transform * major_subdivide * minor_subdivide).xform(Vector2(i,0))
		if (i % (major_subdivision * minor_subdivision) == 0):
			draw_line(Vector2(pos.x,0),Vector2(pos.x,rulerSize),Color.whitesmoke)
			var val:float = (ruler_transform * major_subdivide * minor_subdivide).xform(Vector2(i,0)).x
			draw_string(font,Vector2(pos.x + 2, font.get_height()),str(val))
		else:
			if (i % minor_subdivision == 0):
				draw_line(Vector2(pos.x,rulerSize * 0.33), Vector2(pos.x,rulerSize), Color.whitesmoke)
			else:
				draw_line(Vector2(pos.x,rulerSize * 0.75), Vector2(pos.x,rulerSize), Color.whitesmoke)
	
	# Draw left ruler
	draw_rect(Rect2(Vector2(0, rulerSize), Vector2(rulerSize, size.y)), Color.blue);
	for i in range(ceil(first.y),last.y,1):
		var pos:Vector2 = (my_transform * ruler_transform * major_subdivide * minor_subdivide).xform(Vector2(0, i))
		if (i % (major_subdivision * minor_subdivision) == 0):
			draw_line(Vector2(0, pos.y), Vector2(rulerSize, pos.y), Color.whitesmoke)
			var val:float = (ruler_transform * major_subdivide * minor_subdivide).xform(Vector2(0, i)).y

			var text_xform:Transform2D = Transform2D(-PI / 2.0, Vector2(font.height, pos.y - 2))
			#draw_set_transform_matrix(my_transform * text_xform);
			draw_string(font, Vector2(2,pos.y - 2), str(val), Color.whitesmoke)
			#draw_set_transform_matrix(my_transform);
		else:
			if (i % minor_subdivision == 0):
				draw_line(Vector2(rulerSize * 0.33, pos.y), Vector2(rulerSize, pos.y), Color.whitesmoke)
			else:
				draw_line(Vector2(rulerSize * 0.75, pos.y), Vector2(rulerSize, pos.y), Color.whitesmoke)
	
	draw_rect(Rect2(0,0,rulerSize,rulerSize),Color.gray)

func _draw():
	draw_ruler_guides()

func zoom_on_position(p_zoom:float,p_pos:Vector2):
	if (p_zoom < MIN_ZOOM || p_zoom > MAX_ZOOM):
		return
	
	var prevZoom:float = zoom
	zoom = p_zoom
	var ofs:Vector2 = p_pos
	ofs = ofs / prevZoom - ofs / zoom
	textureRect.rect_position.x = round(textureRect.rect_position.x + ofs.x)
	textureRect.rect_position.y = round(textureRect.rect_position.y + ofs.y)
	zoom_update()

func zoom_update():
	zoom = clamp(zoom,MIN_ZOOM,MAX_ZOOM)
	print(zoom)
	textureRect.rect_scale = Vector2(zoom,zoom)
	update()

func _on_ImageViewport_gui_input(event):
	if (event is InputEventMouseButton):
		
		# Dragging viewport with mouse
		if (event.button_index == BUTTON_MIDDLE and event.is_pressed()):
			set_dragging(true)
			set_drag_start(get_global_mouse_position())
		if (event.button_index == BUTTON_MIDDLE and !event.is_pressed()):
			set_dragging(false)
		
		# Zooming with mouse wheel
		if (event.button_index == BUTTON_WHEEL_DOWN):
			zoom_on_position(zoom * (1 - (0.05 * event.factor)),event.position)
			#zoom += event.factor * zoomMultiplier
			#zoom_update()
		if (event.button_index == BUTTON_WHEEL_UP):
			zoom_on_position(zoom * ((0.95 + (0.05 * event.factor)) / 0.95),event.position)
			#zoom -= event.factor * zoomMultiplier
			#zoom_update()
