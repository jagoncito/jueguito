class_name BituDecoration
extends Node2D

var kind := "tree"

func _draw() -> void:
	if kind == "house":
		_draw_house()
	else:
		_draw_tree()

func _draw_tree() -> void:
	draw_rect(Rect2(-35, -7, 70, 12), Color(0.05, 0.09, 0.05, 0.24))
	draw_rect(Rect2(-9, -95, 18, 95), Color("6e5339"))
	draw_rect(Rect2(-9, -89, 6, 89), Color("96724a"))
	draw_rect(Rect2(-16, -8, 32, 8), Color("5b4933"))
	var foliage := PackedVector2Array([Vector2(-54,-80),Vector2(-54,-115),Vector2(-39,-115),Vector2(-39,-140),Vector2(-15,-140),Vector2(-15,-160),Vector2(16,-160),Vector2(16,-148),Vector2(39,-148),Vector2(39,-125),Vector2(57,-125),Vector2(57,-84),Vector2(34,-84),Vector2(34,-69),Vector2(-26,-69),Vector2(-26,-80)])
	draw_colored_polygon(foliage, Color("284d35"))
	draw_rect(Rect2(-37,-126,54,37),Color("4f7444"))
	draw_rect(Rect2(-13,-146,30,34),Color("63834d"))
	draw_rect(Rect2(-48,-103,26,23),Color("3d643d"))
	draw_rect(Rect2(11,-111,35,25),Color("355b38"))
	draw_rect(Rect2(-28,-119,12,5),Color("7b9858"))
	draw_rect(Rect2(-5,-137,12,5),Color("8ea662"))

func _draw_house() -> void:
	var a := Vector2(-256,-112)
	var b := Vector2(-64,-208)
	var c := Vector2(192,-80)
	var d := Vector2(0,16)
	var rise := Vector2(0,-65)
	draw_colored_polygon(PackedVector2Array([a,b,c,d]), Color("594b36"))
	draw_colored_polygon(PackedVector2Array([a,d,d+rise,a+rise]),Color("b59a6c"))
	draw_colored_polygon(PackedVector2Array([d,c,c+rise,d+rise]),Color("806d4b"))
	var ridge_a := (a+b)/2+Vector2(0,-150)
	var ridge_b := (d+c)/2+Vector2(0,-150)
	draw_colored_polygon(PackedVector2Array([a+rise,ridge_a,ridge_b,d+rise]),Color("8b4f38"))
	draw_colored_polygon(PackedVector2Array([ridge_a,b+rise,c+rise,ridge_b]),Color("633d2e"))
	for i in range(1,6):
		var t := float(i)/6.0
		draw_line((a+rise).lerp(ridge_a,t),(d+rise).lerp(ridge_b,t),Color("a06542"),2)
	draw_rect(Rect2(-85,-78,26,50),Color("443a2b"))
	draw_rect(Rect2(-79,-76,5,46),Color("715738"))
	draw_rect(Rect2(-38,-89,25,21),Color("d7bd7a"))
	draw_rect(Rect2(-27,-89,3,21),Color("715a3d"))
