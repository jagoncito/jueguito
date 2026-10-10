class_name BituFishing
extends Node2D
## Caña de prueba. El avance depende del control del sedal, no de un temporizador.
signal finished(success: bool)
signal bite
enum Stage {IDLE, CASTING, WAITING, REELING, LANDING}
var stage := Stage.IDLE
var player: BituPlayer
var terrain: BituTerrain
var water_point := Vector2.ZERO
var elapsed := 0.0
var reel_time := 0.0
var tension := 0.25
var progress := 0.0
var slack_time := 0.0
var bite_delay := 2.5
var failure_reason := ""
var review_telemetry := false
var telemetry_time := 0.0

func _ready() -> void:
	if OS.has_feature("web"):
		review_telemetry = bool(JavaScriptBridge.eval("new URLSearchParams(location.search).get('verificar') === '1'"))

func start(point: Vector2) -> bool:
	if stage != Stage.IDLE or player.busy or not terrain.is_water(BituTerrain.world_to_cell(point)):
		return false
	if player.global_position.distance_to(point) > 85.0:
		return false
	if not player.begin_fishing(point):
		return false
	water_point = point
	stage = Stage.CASTING
	elapsed = 0.0
	progress = 0.0
	tension = 0.25
	reel_time = 0.0
	slack_time = 0.0
	failure_reason = ""
	queue_redraw()
	print("BITU_FISH_CAST")
	return true

func cancel() -> void:
	if stage != Stage.IDLE:
		failure_reason = "Pesca cancelada."
		_finish(false)

func _process(delta: float) -> void:
	advance(delta,Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT))
	if review_telemetry and stage != Stage.IDLE:
		telemetry_time += delta
		if telemetry_time >= 0.15:
			telemetry_time = 0.0
			print("BITU_FISH_STATE:",JSON.stringify({"stage":stage,"tension":tension,"progress":progress}))

func advance(delta: float, pulling: bool) -> void:
	if stage == Stage.IDLE:
		return
	elapsed += delta
	match stage:
		Stage.CASTING:
			player.set_fishing_pose("pesca-cargar" if elapsed < 0.35 else "pesca-esperar")
			if elapsed >= 0.8:
				stage = Stage.WAITING
				elapsed = 0.0
		Stage.WAITING:
			if elapsed >= bite_delay:
				stage = Stage.REELING
				elapsed = 0.0
				bite.emit()
				print("BITU_FISH_BITE")
		Stage.REELING:
			reel_time += delta
			var pull := 0.5+0.35*sin(reel_time*2.7)+0.15*sin(reel_time*5.3)
			if pulling:
				tension += delta*(0.30+pull*0.42)
				progress += delta*(0.31-pull*0.11)
				slack_time = 0.0
			else:
				tension -= delta*0.65
				progress -= delta*0.025
				slack_time += delta
			progress = clampf(progress,0.0,1.0)
			tension = clampf(tension,0.0,1.0)
			player.set_fishing_pose("pesca-recoger" if pulling else "pesca-esperar")
			if tension >= 1.0 or slack_time > 8.0 or reel_time > 45.0:
				failure_reason = "El sedal se ha roto." if tension >= 1.0 else "El pez se ha escapado."
				_finish(false)
			elif progress >= 1.0:
				stage = Stage.LANDING
				elapsed = 0.0
				player.set_fishing_pose("pesca-recoger")
		Stage.LANDING:
			if elapsed >= 0.5:
				_finish(true)
	queue_redraw()

func _finish(success: bool) -> void:
	stage = Stage.IDLE
	player.end_work()
	queue_redraw()
	finished.emit(success)
	print("BITU_FISH_FINISH:",success)

func _draw() -> void:
	if stage == Stage.IDLE:
		return
	var tip := player.dragon.contact_global(&"sedal")
	if not tip.is_finite():
		return
	var start_point := to_local(tip)
	var end_point := to_local(water_point)
	if stage == Stage.CASTING:
		var cast := clampf((elapsed-0.35)/0.45,0.0,1.0)
		end_point = start_point.lerp(end_point,cast)+Vector2(0,-sin(cast*PI)*22)
	elif stage == Stage.LANDING:
		end_point = end_point.lerp(to_local(player.global_position),clampf(elapsed/0.5,0,1))
	var points := PackedVector2Array()
	for i in range(13):
		var f := i/12.0
		points.append(start_point.lerp(end_point,f)+Vector2(0,sin(f*PI)*(1.0-tension)*10.0))
	draw_polyline(points,Color("c9c8ac"),1.0,false)
	draw_circle(end_point+Vector2(0,1),6,Color(0.7,0.9,0.9,0.2))
	var bob := sin(elapsed*16)*2 if stage == Stage.REELING else sin(elapsed*3)
	draw_rect(Rect2(end_point+Vector2(-2,-3+bob),Vector2(4,5)),Color("db6e38"))
	draw_rect(Rect2(end_point+Vector2(-2,-3+bob),Vector2(4,2)),Color("e6dfbd"))
