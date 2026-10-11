extends SceneTree
func _initialize() -> void: call_deferred("run")
var failure_count := 0
func check(condition: bool, message: String) -> void:
 if not condition:
  push_error(message)
  failure_count += 1
func run() -> void:
 var actor := BituPlayer.new()
 root.add_child(actor)
 actor.set_physics_process(false)
 actor.set_process(false)
 var v := actor.dragon
 var rig := v.articulated
 for d in [0,1,2,3,5,6,7]:
  for running in [false,true]:
   for n in range(64):
    rig.show_gait(d,n/64.0,running)
    check(rig.grounded[0] != rig.grounded[1],"Los pies alternan el apoyo")
    check(is_zero_approx(rig.torso_offset.x),"SUR y diagonales sin salto lateral del tronco")
    check(rig.torso_offset.y>=0 and rig.torso_offset.y<1,"La cresta nunca crece")
    for i in range(2):
     var foot: Dictionary=rig.current.legs[i]
     check(rig.foot_positions[i].distance_to(rig.foot_targets[i])<0.01,"Apoyo alcanzable sin estirar piernas")
     check(is_zero_approx(foot.foot.rotation),"Suela plana al apoyar")
     var vertices: PackedVector2Array=foot.foot.mesh.surface_get_arrays(0)[Mesh.ARRAY_VERTEX]
     var bottom := -INF
     for p in vertices: bottom=maxf(bottom,p.y+foot.foot.position.y)
     check(absf(bottom-rig.foot_targets[i].y)<0.02,"La suela dibujada coincide con el apoyo")
     if rig.grounded[i]:
      check(absf(rig.foot_targets[i].y-foot.ground.y)<=2.01,"Pie de apoyo a nivel de suelo")
   rig.show_gait(d,.125,running)
   var first := rig.foot_positions.duplicate()
   rig.show_gait(d,.625,running)
   check(first[0].distance_to(rig.foot_positions[0])>3 and first[1].distance_to(rig.foot_positions[1])>3,"Cada media zancada cambia de pierna")
 for d in range(8):
  for action in [&"minar",&"talar"]:
   for n in range(63):
    rig.show_work(d,action,n/100.0)
    check(maxf(rig.hand_errors[0],rig.hand_errors[1])<0.01,"Las dos manos conservan el agarre en todo el golpe")
   rig.show_work(d,action,.33)
   var sprite: Sprite2D=rig.current.tool_sprite
   var active: Vector2=rig.current.tool.transform*(sprite.transform*(rig.TOOL_PICK if action==&"minar" else rig.TOOL_AXE))
   var other: Vector2=rig.current.tool.transform*(sprite.transform*(rig.TOOL_AXE if action==&"minar" else rig.TOOL_PICK))
   check(active.y>rig.current.tool.position.y and other.y<rig.current.tool.position.y,"Extremo activo abajo; extremo contrario visible arriba")
   if rig.current.mirrored:active.x*=-1
   check(active.distance_to(rig.contact_local())<0.01,"Contacto registrado pertenece al metal dibujado")
   check(active.distance_to(rig.impact_contact_local(d,action))<0.01,"Impacto fijo evita trasladar cuerpo durante el golpe")
 actor.direction_index=4
 actor.walk_time=.1
 actor.animate_pose(0)
 check(not rig.visible,"Marcha NORTE conserva las poses originales")
 actor.direction_index=2
 actor.walk_time=.1
 actor.sprinting=true
 actor.animate_pose(0)
 check(not rig.visible,"Sprint cardinal conserva las poses originales")
 actor.sprinting=false
 actor.walk_time=0
 actor.animate_pose(0)
 check(not rig.visible and v.body.visible,"Reposo conservado al parar")
 if failure_count==0: print("BITU_DRAGON_GAIT_SMOKE_OK: apoyos reales, altura, manos y ambos extremos en ocho vistas")
 quit(0 if failure_count==0 else 1)
