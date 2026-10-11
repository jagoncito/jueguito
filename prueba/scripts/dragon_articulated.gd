class_name BituDragonArticulated
extends Node2D
## Articulaciones del atlas limpio: pies, rodillas, brazos y herramienta unidos.
const DATA := "res://assets/personajes/dragon/articulaciones.json"
const TOOL_TEXTURE := "res://assets/herramientas/pico-hacha/pico-hacha-hierro.png"
const DIRECTIONS := [Vector2.DOWN,Vector2(-1,1),Vector2.LEFT,Vector2(-1,-1),Vector2.UP,Vector2(1,-1),Vector2.RIGHT,Vector2(1,1)]
static var cached_definitions: Dictionary = {}
var definitions: Dictionary
var assemblies: Dictionary = {}
var current: Dictionary
var direction := 0
var active_contact := Vector2.INF
var working_end := ""
var foot_targets: Array[Vector2] = []
var foot_positions: Array[Vector2] = []
var grounded: Array[bool] = []
var torso_offset := Vector2.ZERO
var walking := false
var active_view := ""
var hand_errors: Array[float] = []
var action_clock := 0.0
var source_texture: Texture2D
var tool_texture: Texture2D
var limb_texture: Texture2D
const TOOL_FACTOR := 0.05
const TOOL_GRIP := Vector2(630,830)
const TOOL_PICK := Vector2(250,414)
const TOOL_AXE := Vector2(1000,350)

func _ready() -> void:
 texture_filter=CanvasItem.TEXTURE_FILTER_NEAREST
 # El registro es de solo lectura; nodos, apoyos y poses son propios de cada actor.
 if cached_definitions.is_empty():
  cached_definitions=JSON.parse_string(FileAccess.get_file_as_string(DATA)).views
 definitions=cached_definitions
 source_texture=load("res://assets/personajes/dragon/piezas-articuladas.png")
 tool_texture=load(TOOL_TEXTURE)
 limb_texture=load("res://assets/personajes/dragon/piezas-articuladas.png")

func _point(value: Array) -> Vector2:
 return Vector2(value[0],value[1])

func _mesh(points: Array, pivot: Vector2, factor: float, tex: Texture2D) -> MeshInstance2D:
 var vertices := PackedVector2Array()
 var uvs := PackedVector2Array()
 for point in points:
  var p:=_point(point)
  vertices.append((p-pivot)*factor)
  uvs.append(p/Vector2(tex.get_size()))
 var arrays := []
 arrays.resize(Mesh.ARRAY_MAX)
 arrays[Mesh.ARRAY_VERTEX]=vertices
 arrays[Mesh.ARRAY_TEX_UV]=uvs
 var mesh:=ArrayMesh.new()
 mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,arrays)
 var node:=MeshInstance2D.new()
 node.mesh=mesh
 node.texture=tex
 return node

func _limb(spec: Dictionary, anchor: Vector2, factor: float, root: Node2D) -> Dictionary:
 if spec.get("clean",false):return _clean_limb(spec,root)
 var start:=_point(spec.joints[0])
 var middle:=_point(spec.joints[1])
 var end:=_point(spec.joints[2])
 var upper:=_mesh(spec.upper_triangles,start,factor,source_texture)
 var lower:=_mesh(spec.lower_triangles,middle,factor,source_texture)
 root.add_child(upper);root.add_child(lower)
 var placed:=_point(spec.get("placement",spec.joints[0]))
 var shift:=(placed-start)*factor
 var result:={"upper":upper,"lower":lower,"start":(start-anchor)*factor+shift,
  "middle":(middle-anchor)*factor+shift,"end":(end-anchor)*factor+shift,
  "length_a":start.distance_to(middle)*factor,"length_b":middle.distance_to(end)*factor,
  "rest_a":(middle-start).angle(),"rest_b":(end-middle).angle(),"bend":spec.bend}
 if spec.has("ground"):
  result.ground=(_point(spec.ground)-anchor)*factor+shift
  result.sole_offset=(_point(spec.ground)-end)*factor
  result.foot=_mesh(spec.foot_triangles,end,factor,source_texture)
  root.add_child(result.foot)
 return result

func _clean_limb(spec: Dictionary, root: Node2D) -> Dictionary:
 var p:=_point(spec.upper_pivot);var e:=_point(spec.upper_end)
 var q:=_point(spec.lower_pivot);var f:=_point(spec.lower_end)
 var upper:=_mesh(spec.upper_triangles,p,float(spec.length_a)/p.distance_to(e),limb_texture)
 var lower:=_mesh(spec.lower_triangles,q,float(spec.length_b)/q.distance_to(f),limb_texture)
 root.add_child(upper);root.add_child(lower)
 var result:={"upper":upper,"lower":lower,"start":_point(spec.start),"length_a":spec.length_a,"length_b":spec.length_b,
  "rest_a":(e-p).angle(),"rest_b":(f-q).angle(),"bend":spec.bend}
 if spec.has("ground"):
  result.ground=_point(spec.ground);result.sole_offset=_point(spec.sole_offset)
  result.end=result.ground-result.sole_offset
  result.foot=_mesh(spec.foot_triangles,_point(spec.foot_pivot),spec.foot_scale,limb_texture)
  root.add_child(result.foot)
 else:result.end=_point(spec.end)
 upper.scale.x=float(spec.width_factor)
 lower.scale.x=float(spec.lower_width_factor)
 return result

func _assembly(key: String) -> Dictionary:
 if assemblies.has(key): return assemblies[key]
 var spec:Dictionary=definitions[key]
 var anchor:=_point(spec.anchor)
 var factor:float=spec.scale
 var root:=Node2D.new();add_child(root)
 var legs:Array[Dictionary]=[]
 var arms:Array[Dictionary]=[]
 var repairs:Array[MeshInstance2D]=[]
 # Las extremidades lejanas quedan detrás del tronco.
 legs.append(_limb(spec.legs[0],anchor,factor,root))
 arms.append(_limb(spec.arms[0],anchor,factor,root))
 for triangles in spec.repair_triangles:
  # Relleno azul del torso, detrás de su contorno y de las articulaciones.
  var repair:=_mesh(triangles,anchor,factor,source_texture)
  # Reutilizar sombreado azul opaco del mismo cuerpo, sin dibujar imágenes nuevas.
  var arr:=PackedVector2Array()
  for p in triangles: arr.append(Vector2(420,316)/Vector2(source_texture.get_size()))
  var arrays:=repair.mesh.surface_get_arrays(0);arrays[Mesh.ARRAY_TEX_UV]=arr
  var mesh:=ArrayMesh.new();mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,arrays)
  repair.mesh=mesh;root.add_child(repair);repairs.append(repair)
 legs.append(_limb(spec.legs[1],anchor,factor,root))
 var trunk:=_mesh(spec.body_triangles,anchor,factor,source_texture);root.add_child(trunk)
 var tool:=Sprite2D.new();tool.centered=false;tool.texture=tool_texture
 tool.scale=Vector2.ONE*TOOL_FACTOR
 tool.position=-TOOL_GRIP*TOOL_FACTOR
 var holder:=Node2D.new();root.add_child(holder);holder.add_child(tool)
 arms.append(_limb(spec.arms[1],anchor,factor,root))
 if key in ["N","NW"]:
  root.move_child(holder,trunk.get_index())
 if key=="N":root.move_child(trunk,root.get_child_count()-1)
 var a:={"root":root,"body":trunk,"repairs":repairs,"legs":legs,"arms":arms,"tool":holder,"tool_sprite":tool,"anchor":anchor,"factor":factor,"mirrored":false}
 assemblies[key]=a
 return a

func _select(index: int) -> void:
 direction=posmod(index,8)
 var key:String=["S","SW","W","NW","N","NW","W","SW"][direction]
 for a in assemblies.values():a.root.visible=false
 current=_assembly(key);current.root.visible=true
 current.mirrored=direction in [5,6,7]
 current.root.scale=Vector2(-1 if current.mirrored else 1,1)
 active_view=key

func _solve(part: Dictionary, target: Vector2, offset: Vector2, bend: float) -> Vector2:
 var origin:Vector2=part.start+offset
 var delta:=target-origin
 var length_a:float=part.length_a;var length_b:float=part.length_b
 var distance:=clampf(delta.length(),absf(length_a-length_b)+0.001,length_a+length_b-0.001)
 var angle:=delta.angle()
 var opening:=acos(clampf((length_a*length_a+distance*distance-length_b*length_b)/(2*length_a*distance),-1,1))
 var elbow:=origin+Vector2.from_angle(angle+opening*bend)*length_a
 var finish:=origin+delta.normalized()*distance
 part.upper.position=origin
 part.upper.rotation=(elbow-origin).angle()-float(part.rest_a)
 part.lower.position=elbow
 part.lower.rotation=(finish-elbow).angle()-float(part.rest_b)
 return finish

func show_gait(index: int, phase: float, running: bool) -> void:
 _select(index)
 walking=true;active_contact=Vector2.INF;working_end=""
 current.tool.visible=false
 foot_targets.clear();foot_positions.clear();grounded.clear()
 var cycle:=fposmod(phase,1.0)
 # Descenso pequeño al flexionar rodillas; nunca un salto lateral del tronco.
 torso_offset=Vector2(0,(0.4 if running else 0.2)+(0.35 if running else 0.2)*cos(cycle*TAU*2))
 current.body.position=torso_offset
 for repair in current.repairs:repair.position=torso_offset
 var aim:Vector2=DIRECTIONS[[0,1,2,3,4,3,2,1][direction]].normalized()
 var stride:=Vector2(aim.x*(6.5 if running else 5.0),aim.y*2.0)
 for i in range(2):
  var q:=fposmod(cycle+i*0.5,1.0)
  var stance:=q<0.5
  var forward:=1.0-4.0*q if stance else -1.0+4.0*(q-0.5)
  var lift:=0.0 if stance else sin((q-0.5)*TAU)*(6.0 if running else 4.0)
  var neutral:Vector2=current.legs[i].ground
  if active_view!="S":
   var center:float=(current.legs[0].start.x+current.legs[1].start.x)*0.5
   neutral.x=center+(-1 if i==0 else 1)*(2.0 if active_view=="W" else 3.0)
  var foot:Vector2=neutral+stride*forward-Vector2(0,lift)
  foot_targets.append(foot)
  var ankle:=_solve(current.legs[i],foot-current.legs[i].sole_offset,torso_offset,current.legs[i].bend)
  current.legs[i].foot.position=ankle
  current.legs[i].foot.rotation=0.0
  foot_positions.append(ankle+current.legs[i].sole_offset)
  grounded.append(stance)
  # Brazo contrario a la pierna adelantada, movimiento desde hombro y codo.
  var wrist:Vector2=current.arms[i].end-stride*forward*0.75+torso_offset
  _solve(current.arms[i],wrist,torso_offset,current.arms[i].bend)

func show_work(index: int, action: StringName, clock: float) -> void:
 _select(index)
 walking=false;action_clock=clock
 working_end="pick_tip" if action==&"minar" else "axe_edge"
 current.tool.visible=true
 # Preparación -> levantar -> golpe -> seguimiento -> recuperación.
 var angle:float;var grip:Vector2
 var base:=Vector2(-9,-31)
 if active_view=="S":base=Vector2(-3,-34)
 elif active_view=="NW":base=Vector2(-8,-42)
 elif active_view=="N":base=Vector2(-2,-48)
 var raised:=base+Vector2(8,-13)
 if active_view=="S":raised=base+Vector2(-3,-10)
 elif active_view=="NW":raised=base+Vector2(4,-3)
 elif active_view=="N":raised=base+Vector2(-2,1)
 var ready:=base+Vector2(1,1)
 var recovery:=base+Vector2(-2,3)
 if clock<0.12:
  var t:=smoothstep(0,0.12,clock)
  angle=lerpf(-70,-12,t);grip=ready.lerp(raised,t)
 elif clock<0.33:
  var t:=clampf((clock-0.12)/0.21,0,1);t=t*t
  angle=lerpf(-12,-90,t);grip=raised.lerp(base,t)
 elif clock<0.43:
  var t:=smoothstep(0.33,0.43,clock)
  angle=lerpf(-90,-109,t);grip=base.lerp(recovery,t)
 else:
  var t:=smoothstep(0.43,0.62,clock)
  angle=lerpf(-109,-70,t);grip=recovery.lerp(ready,t)
 torso_offset=Vector2(0,1.1*sin(clampf(clock/0.62,0,1)*PI))
 current.body.position=torso_offset
 for repair in current.repairs:repair.position=torso_offset
 for i in range(2):
  var ankle:=_solve(current.legs[i],current.legs[i].end,torso_offset,current.legs[i].bend)
  current.legs[i].foot.position=ankle
  current.legs[i].foot.rotation=0.0
 current.tool.position=grip
 current.tool.rotation=deg_to_rad(angle)
 var flip:=action==&"talar"
 current.tool_sprite.scale=Vector2(-1 if flip else 1,1)*TOOL_FACTOR
 current.tool_sprite.position=Vector2(TOOL_GRIP.x if flip else -TOOL_GRIP.x,-TOOL_GRIP.y)*TOOL_FACTOR
 var secondary:Vector2=current.tool.position+Vector2(0,-7).rotated(current.tool.rotation)
 hand_errors=[_solve(current.arms[0],secondary,torso_offset,current.arms[0].bend).distance_to(secondary),_solve(current.arms[1],current.tool.position,torso_offset,current.arms[1].bend).distance_to(current.tool.position)]
 var point:Vector2=(TOOL_PICK if action==&"minar" else TOOL_AXE)-TOOL_GRIP
 if flip:point.x*=-1
 point*=TOOL_FACTOR
 active_contact=current.tool.position+point.rotated(current.tool.rotation)
 if current.mirrored:active_contact.x*=-1

func contact_local() -> Vector2:
 return active_contact

func impact_contact_local(index: int, action: StringName) -> Vector2:
 var view:String=["S","SW","W","NW","N","NW","W","SW"][posmod(index,8)]
 var base:=Vector2(-9,-31)
 if view=="S":base=Vector2(-3,-34)
 elif view=="NW":base=Vector2(-8,-42)
 elif view=="N":base=Vector2(-2,-48)
 var point:Vector2=(TOOL_PICK if action==&"minar" else TOOL_AXE)-TOOL_GRIP
 if action==&"talar":point.x*=-1
 var contact:=base+(point*TOOL_FACTOR).rotated(-PI/2)
 if index in [5,6,7]:contact.x*=-1
 return contact
