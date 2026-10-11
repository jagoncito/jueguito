class_name BituIslandFixture
extends StaticBody2D
## Elementos de escena pequeños; no añade recetas, servicios ni nuevos sistemas.
var kind := "vitrina"
var caption := ""
var dimensions := Vector2(110,50)

func _ready() -> void:
	var collision := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = Vector2(22,12) if kind == "senal" else dimensions*Vector2(1,0.7)
	collision.shape = shape
	collision.position.y = -shape.size.y/2
	add_child(collision)

func _draw() -> void:
	var w := dimensions.x/2
	var h := dimensions.y/2
	if kind == "senal":
		draw_rect(Rect2(-4,-53,8,53),Color("64462b"))
		draw_rect(Rect2(-83,-76,166,32),Color("b38c58"))
		draw_rect(Rect2(-81,-74,162,28),Color("765637"),false,2)
		var font := ThemeDB.fallback_font
		var text_width := font.get_string_size(caption,HORIZONTAL_ALIGNMENT_LEFT,-1,12).x
		draw_string(font,Vector2(-text_width/2,-55),caption,HORIZONTAL_ALIGNMENT_CENTER,160,12,Color("fff0ca"))
		return
	var top := PackedVector2Array([Vector2(-w,-h-26),Vector2(0,-h*2-26),Vector2(w,-h-26),Vector2(0,-26)])
	if kind == "yunque":
		draw_colored_polygon(PackedVector2Array([Vector2(-25,-40),Vector2(30,-40),Vector2(18,-25),Vector2(16,-10),Vector2(27,-5),Vector2(-21,0),Vector2(-15,-19),Vector2(-23,-26),Vector2(-48,-32)]),Color("5f6e72"))
		draw_line(Vector2(-45,-33),Vector2(26,-39),Color("c2cbd0"),3)
		draw_rect(Rect2(-18,-10,36,14),Color("61482e"))
		return
	draw_colored_polygon(PackedVector2Array([top[0],top[3],Vector2(0,0),Vector2(-w,-h)]),Color("624a34"))
	draw_colored_polygon(PackedVector2Array([top[3],top[2],Vector2(w,-h),Vector2(0,0)]),Color("7b5c3c"))
	draw_colored_polygon(top,Color("ae8960"))
	if kind == "vitrina":
		var glass := PackedVector2Array([top[0]-Vector2(0,20),top[1]-Vector2(0,20),top[2]-Vector2(0,20),top[3]-Vector2(0,20)])
		draw_colored_polygon(glass,Color(0.55,0.78,0.73,0.28))
		draw_polyline(glass+PackedVector2Array([glass[0]]),Color("96bbb0"),2)
		for i in [0,2,3]: draw_line(top[i],glass[i],Color("c2d6c8"),2)
	elif kind == "laboratorio":
		for i in range(5):
			var p := Vector2(-w+16+i*20,-h-35)
			draw_rect(Rect2(p,Vector2(10,17)),[Color("79a79a"),Color("a593af"),Color("d4ad6a")][i%3])
			draw_rect(Rect2(p+Vector2(3,-5),Vector2(4,6)),Color("d7d7b9"))
		draw_circle(Vector2(28,-h-40),12,Color("bb7846"))
		draw_line(Vector2(28,-h-43),Vector2(28,-h-66),Color("e0a363"),5)
	else:
		draw_line(top[0]+Vector2(8,0),top[2]-Vector2(8,0),Color("d5b784"),2)
