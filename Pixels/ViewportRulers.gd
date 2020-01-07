extends Control

var zoom:float setget set_zoom,get_zoom
func set_zoom(val:float):
	zoom = val
	update()
func get_zoom():
	return zoom

var view_transform:Transform2D setget set_view_transform,get_view_transform
func set_view_transform(transform:Transform2D):
	view_transform = transform
	update()
func get_view_transform():
	return view_transform

const MAJOR_SUBDIVS:int = 2
const MINOR_SUBDIVS:int = 5
const RULER_SIZE:int = 24
const RULE:float = 100.0

func draw_ruler_guides():
	var size = get_parent().get_rect().size
	var font = get_font("rulers","EditorFonts")
	var ruler_transform:Transform2D = Transform2D()
	var basic_rule:float = RULE
	var i:int = 0
	while (basic_rule * get_zoom() > RULE):
		basic_rule /= float(MINOR_SUBDIVS) if (i % 2) else float(MAJOR_SUBDIVS)
		i += 1
	i = 0
	while (basic_rule * get_zoom() < RULE):
		basic_rule *= float(MAJOR_SUBDIVS) if (i % 2) else float(MINOR_SUBDIVS)
		i += 1
	ruler_transform = ruler_transform.scaled(Vector2(basic_rule,basic_rule))

	var major_subdivide:Transform2D = Transform2D()
	major_subdivide = major_subdivide.scaled(Vector2(1.0 / MAJOR_SUBDIVS, 1.0 / MAJOR_SUBDIVS))
		
	var minor_subdivide:Transform2D = Transform2D()
	minor_subdivide = minor_subdivide.scaled(Vector2(1.0 / MINOR_SUBDIVS, 1.0 / MINOR_SUBDIVS))
	
	var first:Vector2 = (get_view_transform() * ruler_transform * major_subdivide * minor_subdivide).affine_inverse().xform(Vector2(RULER_SIZE,RULER_SIZE))
	var last:Vector2 = (get_view_transform() * ruler_transform * major_subdivide * minor_subdivide).affine_inverse().xform(size)
	
	# draw top ruler
	draw_rect(Rect2(Vector2(RULER_SIZE,0),Vector2(size.x,RULER_SIZE)),Color.blue)
	for i in range(ceil(first.x),last.x,1):
		var pos:Vector2 = (get_view_transform() * ruler_transform * major_subdivide * minor_subdivide).xform(Vector2(i,0))
		if (i % (MAJOR_SUBDIVS * MINOR_SUBDIVS) == 0):
			draw_line(Vector2(pos.x,0),Vector2(pos.x,RULER_SIZE),Color.whitesmoke)
			var val:float = (ruler_transform * major_subdivide * minor_subdivide).xform(Vector2(i,0)).x
			draw_string(font,Vector2(pos.x + 2, font.get_height()),str(val))
		else:
			if (i % MINOR_SUBDIVS == 0):
				draw_line(Vector2(pos.x,RULER_SIZE * 0.33), Vector2(pos.x,RULER_SIZE), Color.whitesmoke)
			else:
				draw_line(Vector2(pos.x,RULER_SIZE * 0.75), Vector2(pos.x,RULER_SIZE), Color.whitesmoke)
	
	# Draw left ruler
	draw_rect(Rect2(Vector2(0, RULER_SIZE), Vector2(RULER_SIZE, size.y)), Color.blue);
	for i in range(ceil(first.y),last.y,1):
		var pos:Vector2 = (get_view_transform() * ruler_transform * major_subdivide * minor_subdivide).xform(Vector2(0, i))
		if (i % (MAJOR_SUBDIVS * MINOR_SUBDIVS) == 0):
			draw_line(Vector2(0, pos.y), Vector2(RULER_SIZE, pos.y), Color.whitesmoke)
			var val:float = (ruler_transform * major_subdivide * minor_subdivide).xform(Vector2(0, i)).y
			draw_string(font, Vector2(2,pos.y - 2), str(val), Color.whitesmoke)
		else:
			if (i % MINOR_SUBDIVS == 0):
				draw_line(Vector2(RULER_SIZE * 0.33, pos.y), Vector2(RULER_SIZE, pos.y), Color.whitesmoke)
			else:
				draw_line(Vector2(RULER_SIZE * 0.75, pos.y), Vector2(RULER_SIZE, pos.y), Color.whitesmoke)
	
	draw_rect(Rect2(0,0,RULER_SIZE,RULER_SIZE),Color.gray)

func _draw():
	draw_ruler_guides()