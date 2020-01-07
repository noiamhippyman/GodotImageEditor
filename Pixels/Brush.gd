extends Node2D

func _draw():
	print("BRUSH DRAW")
	#draw_rect(Rect2(Vector2.ZERO,get_parent().size),Color.white)
	draw_circle(Vector2.ZERO,16,Color.white)