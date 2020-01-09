extends Viewport

class_name Layer
func update():
	set_update_mode(Viewport.UPDATE_ONCE)

class Brush_Circle extends Node2D:
	var radius:float setget set_radius,get_radius
	func set_radius(r:float):
		radius = r
		update()
	func get_radius():
		return radius
	
	var color:Color setget set_color,get_color
	func set_color(c:Color):
		color = c
		update()
	func get_color():
		return color
	
	func _init(rad:float,col:Color):
		set_radius(rad)
		set_color(col)
	
	func _draw():
		draw_circle(Vector2.ZERO,get_radius(),get_color())

func _init(name:String="Layer",size:Vector2=Vector2(512,512)):
	set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
	set_update_mode(Viewport.UPDATE_DISABLED)
	self.name = name
	self.size = size
	
	add_child(Brush_Circle.new(16,Color.white))