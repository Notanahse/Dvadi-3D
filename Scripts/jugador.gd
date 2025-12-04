extends CharacterBody3D

@export var h_sensibilidad = 0.005
@export var v_sensibilidad = 0.01
@export var velocidad = 6.0
@export var velocidad_correr = 9.0    
@export var salto_fuerza = 10.0
@export var gravedad = 30.0

@export var fuerza_disparo = 20.0
@export var fuerza_pateo = 20.0
@export var pelota: RigidBody3D

var velocidad_y = 0.0
var golpe_pateo_activo = false  

@onready var mesh = $MeshInstance3D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	cambiar_skin_por_equipo(Global.equipo_seleccionado)

func cambiar_skin_por_equipo(equipo: String):
	var textura_path = ""
	match equipo:
		"Boca": textura_path = "res://Escudos/Boca.png"
		"Independiente": textura_path = "res://Escudos/Independiente.png"
		"Racing": textura_path = "res://Escudos/Racing.png"
		"River": textura_path = "res://Escudos/River.png"
		"Poli": textura_path = "res://Escudos/Poli.png"
		"SanLorenzo": textura_path = "res://Escudos/SanLorenzo.png"
	var material = StandardMaterial3D.new()
	material.albedo_texture = load(textura_path)
	material.roughness = 1.0
	material.metallic = 0.0
	mesh.material_override = material

func _input(event):
	if event.device != 0 and not (event is InputEventMouseMotion):
		return

	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * h_sensibilidad)
		var nueva_rot_x = clamp($Camera3D.rotation.x - event.relative.y * v_sensibilidad, deg_to_rad(-80), deg_to_rad(80))
		$Camera3D.rotation.x = nueva_rot_x

	if event.is_action_pressed("patear"):
		if not golpe_pateo_activo:
			patear_pelota()
			golpe_pateo_activo = true

	if event.is_action_released("patear"):
		golpe_pateo_activo = false

	if event.is_action_pressed("disparo"):
		disparar_pelota()


func _physics_process(delta):
	var direccion = Vector3.ZERO
	if Input.is_key_pressed(KEY_W): direccion.z -= 1
	if Input.is_key_pressed(KEY_S): direccion.z += 1
	if Input.is_key_pressed(KEY_A): direccion.x -= 1
	if Input.is_key_pressed(KEY_D): direccion.x += 1

	if direccion.length() > 0:
		direccion = direccion.normalized()

	var vel_actual = velocidad
	if Input.is_action_pressed("run"):
		vel_actual = velocidad_correr

	var direccion_global = (global_transform.basis * direccion).normalized() if direccion.length() > 0 else Vector3.ZERO
	var vel_horizontal = direccion_global * vel_actual

	if not is_on_floor():
		velocidad_y -= gravedad * delta
	else:
		if Input.is_key_pressed(KEY_SPACE):
			velocidad_y = salto_fuerza
		else:
			velocidad_y = 0.0

	velocity.x = vel_horizontal.x
	velocity.z = vel_horizontal.z
	velocity.y = velocidad_y
	move_and_slide()


func esta_cerca_de_pelota(radio: float = 0.1) -> bool:
	if not pelota: return false
	return global_transform.origin.distance_to(pelota.global_transform.origin) <= radio


func patear_pelota():
	if not pelota or not esta_cerca_de_pelota(1.0):
		return

	var dir = -$Camera3D.global_transform.basis.z
	dir = dir.normalized()
	dir.y = clamp(dir.y, -0.5, 0.5)

	var impulso = dir * fuerza_pateo
	if pelota.has_method("apply_impulse"):
		pelota.apply_impulse(Vector3.ZERO, impulso)
	else:
		pelota.linear_velocity += impulso


func disparar_pelota():
	if not pelota or not esta_cerca_de_pelota(1.5):
		return

	var dir = -$Camera3D.global_transform.basis.z
	dir = dir.normalized()
	dir.y = clamp(dir.y, -0.5, 0.5)

	pelota.linear_velocity = dir * fuerza_disparo

	if Input.is_action_pressed("disparo_curva_izquierda"):
		pelota.angular_velocity = Vector3(0, 10, 0)
	elif Input.is_action_pressed("disparo_curva_derecha"):
		pelota.angular_velocity = Vector3(0, -10, 0)


func _on_push_area_body_entered(body: Node3D) -> void:
	if body is RigidBody3D:
		var dir = (body.global_transform.origin - global_transform.origin).normalized()
		body.apply_impulse(dir * 6)
