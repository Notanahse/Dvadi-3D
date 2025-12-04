extends CharacterBody3D

@export var h_sensibilidad = 2.0
@export var v_sensibilidad = 1.5
@export var velocidad = 6.0
@export var velocidad_correr = 9.0
@export var salto_fuerza = 10.0
@export var gravedad = 30.0

@export var fuerza_pateo = 20
@export var pelota: RigidBody3D

var joy_id := -1
var velocidad_y := 0.0

const BOTON_PATEAR_PS := 3

@onready var cam = $Camera3D

func _ready():
	var pads = Input.get_connected_joypads()
	if pads.size() > 0:
		joy_id = pads[0]
	else:
		push_warning("NO HAY JOYSTICK CONECTADO")


func _physics_process(delta):
	if joy_id == -1:
		return

	# MOVIMIENTO
	var x = Input.get_joy_axis(joy_id, JOY_AXIS_LEFT_X)
	var z = Input.get_joy_axis(joy_id, JOY_AXIS_LEFT_Y)

	var deadzone = 0.15
	if abs(x) < deadzone: x = 0
	if abs(z) < deadzone: z = 0

	var direccion = Vector3(x, 0, z)
	direccion = direccion.normalized() if direccion.length() > 0 else Vector3.ZERO

	var r2 := Input.get_joy_axis(joy_id, JOY_AXIS_TRIGGER_RIGHT)
	var vel_actual = velocidad
	if r2 > 0.5:
		vel_actual = velocidad_correr

	var direccion_global = (global_transform.basis * direccion).normalized() if direccion != Vector3.ZERO else Vector3.ZERO
	var vel_horizontal = direccion_global * vel_actual

	var lx = Input.get_joy_axis(joy_id, JOY_AXIS_RIGHT_X)
	var ly = Input.get_joy_axis(joy_id, JOY_AXIS_RIGHT_Y)

	if abs(lx) < 0.12: lx = 0
	if abs(ly) < 0.12: ly = 0

	rotate_y(-lx * h_sensibilidad * delta)
	cam.rotation.x = clamp(
		cam.rotation.x - ly * v_sensibilidad * delta,
		deg_to_rad(-80),
		deg_to_rad(80)
	)

	if not is_on_floor():
		velocidad_y -= gravedad * delta
	else:
		if Input.is_joy_button_pressed(joy_id, JOY_BUTTON_A):
			velocidad_y = salto_fuerza
		else:
			velocidad_y = 0.0

	velocity = Vector3(vel_horizontal.x, velocidad_y, vel_horizontal.z)
	move_and_slide()

	# PATEAR
	if Input.is_joy_button_pressed(joy_id, BOTON_PATEAR_PS) and esta_cerca_de_pelota():
		patear_pelota()



func esta_cerca_de_pelota(radio: float = 1.5) -> bool:
	if pelota == null:
		return false

	return global_transform.origin.distance_to(pelota.global_transform.origin) <= radio


func patear_pelota():
	if pelota == null:
		return

	if not esta_cerca_de_pelota():
		print("Demasiado lejos para patear")
		return


	var dir = -cam.global_transform.basis.z
	dir = dir.normalized()
	dir.y = clamp(dir.y, -0.4, 0.5)

	if dir.length() < 0.1:
		dir = -global_transform.basis.z.normalized()

	var impulso = dir * fuerza_pateo
	pelota.apply_impulse(impulso)

	print("PATEADO!")


func _on_push_area_body_entered(body: Node3D) -> void:
	if body is RigidBody3D:
		var dir = (body.global_transform.origin - global_transform.origin).normalized()
		body.apply_impulse(dir * 6)
