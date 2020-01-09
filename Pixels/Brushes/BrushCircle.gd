extends Node2D
class_name BrushCircle

var radius:float setget set_radius,get_radius
func set_radius(radius:float):
	self.radius = radius
	update()
func get_radius():
	return radius

var color:Color setget set_color,get_color
func set_color(color:Color):
	self.color = color
	update()
func get_color():
	return color

func _init(radius:float,color:Color):
	set_radius(radius)
	set_color(color)

func _draw():
	draw_circle(Vector2.ZERO,get_radius(),get_color())