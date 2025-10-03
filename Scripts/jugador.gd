extends CharacterBody3D

@export var h_sensibilidad = 0.005
@export var v_sensibilidad = 0.01
@export var velocidad = 5.0
@export var velocidad_agachado = 2.5
@export var salto_fuerza = 10.0
@export var gravedad = 30.0
@export var altura_normal = 0.6
@export var altura_agachado = 0.3

@export var fuerza_disparo = 20.0
@export var fuerza_pateo = 20.0
@export var pelota: RigidBody3D

var velocidad_y = 0.0
var agachado = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$Camera3D.position.y = altura_normal

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * h_sensibilidad)
		var nueva_rot_x = clamp($Camera3D.rotation.x - event.relative.y * v_sensibilidad, deg_to_rad(-80), deg_to_rad(80))
		$Camera3D.rotation.x = nueva_rot_x

	if event.is_action_pressed("golpear"):
		realizar_golpe()

	if event.is_action_pressed("disparo"):
		disparar_pelota()

	if event.is_action_pressed("patear"):
		patear_pelota()

func _physics_process(delta):
	var direccion = Vector3.ZERO
	if Input.is_action_pressed("ui_up"):
		direccion.z -= 1
	if Input.is_action_pressed("ui_down"):
		direccion.z += 1
	if Input.is_action_pressed("ui_left"):
		direccion.x -= 1
	if Input.is_action_pressed("ui_right"):
		direccion.x += 1

	if direccion.length() > 0:
		direccion = direccion.normalized()

	var direccion_global = (global_transform.basis * direccion).normalized() if direccion.length() > 0 else Vector3.ZERO

	var vel_horizontal = direccion_global * velocidad

	if not is_on_floor():
		velocidad_y -= gravedad * delta
	else:
		if Input.is_action_just_pressed("ui_accept"):
			velocidad_y = salto_fuerza
		else:
			velocidad_y = 0.0

	if Input.is_action_pressed("agacharse"):
		if not agachado:
			agachado = true
			$Camera3D.position.y = altura_agachado
	else:
		if agachado:
			agachado = false
			$Camera3D.position.y = altura_normal

	velocity.x = vel_horizontal.x
	velocity.z = vel_horizontal.z
	velocity.y = velocidad_y
	move_and_slide()

func esta_cerca_de_pelota(radio: float = 3.0) -> bool:
	if not pelota:
		return false
	return global_transform.origin.distance_to(pelota.global_transform.origin) <= radio

func patear_pelota():
	if not pelota or not esta_cerca_de_pelota(3.0):
		return

	var dir = -$Camera3D.global_transform.basis.z.normalized()
	dir.y = 0.18
	var impulso = dir * fuerza_pateo

	if pelota.has_method("apply_impulse"):
		pelota.apply_impulse(Vector3.ZERO, impulso)
	else:
		pelota.linear_velocity += impulso

func disparar_pelota():
	if not pelota or not esta_cerca_de_pelota(3.5):
		return

	var dir = -$Camera3D.global_transform.basis.z.normalized()
	dir.y = 0.25
	pelota.linear_velocity = dir * fuerza_disparo + Vector3.UP * (fuerza_disparo * 0.2)

	if Input.is_action_pressed("disparo_curva_izquierda"):
		pelota.angular_velocity = Vector3(0, 10, 0)
	elif Input.is_action_pressed("disparo_curva_derecha"):
		pelota.angular_velocity = Vector3(0, -10, 0)

func realizar_golpe():
	var ray = $Camera3D.get_node_or_null("RayCast3D")
	if ray and ray.is_colliding():
		var obj = ray.get_collider()
		if obj and obj.has_method("break_apart"):
			obj.break_apart()
		return

	var from = $Camera3D.global_transform.origin
	var to = from + (-$Camera3D.global_transform.basis.z) * 3.0
	var space_state = get_world_3d().direct_space_state

	var params = PhysicsRayQueryParameters3D.new()
	params.from = from
	params.to = to
	params.exclude = [self]

	var result = space_state.intersect_ray(params)
	if result and result.has("collider"):
		var obj = result.get("collider")
		if obj and obj.has_method("break_apart"):
			obj.break_apart()
