extends CharacterBody3D
@export var velocidad = 5.0
@export var fuerza_pateo = 25.0
@export var pelota: RigidBody3D
@export var arco_enemigo: StaticBody3D

var velocidad_y = 0.0
@export var gravedad = 30.0

var tiempo_ultimo_pateo = 0.0
@export var cooldown_pateo = 1.0
@export var tiempo_preparacion = 0.5
var preparando_pateo = false
var timer_preparacion = 0.0

@export var velocidad_giro = 15.0
@export var distancia_para_patear = 1.5

func _physics_process(delta):
	if not pelota or not arco_enemigo:
		return

	tiempo_ultimo_pateo += delta

	var objetivo = pelota.global_transform.origin
	var direccion = (objetivo - global_transform.origin)
	direccion.y = 0

	if direccion.length() > 0.1:
		var dir_normalizada = direccion.normalized()
		velocity.x = dir_normalizada.x * velocidad
		velocity.z = dir_normalizada.z * velocidad
	else:
		velocity.x = 0
		velocity.z = 0

	if direccion.length() <= distancia_para_patear and tiempo_ultimo_pateo >= cooldown_pateo and not preparando_pateo:
		preparando_pateo = true
		timer_preparacion = 0.0

	if direccion.length() > 0.1:
		var target_rotation = Vector3(0, atan2(direccion.x, direccion.z), 0)
		rotation.y = lerp_angle(rotation.y, target_rotation.y, velocidad_giro * delta)

	if not is_on_floor():
		velocidad_y -= gravedad * delta
	else:
		velocidad_y = 0
	velocity.y = velocidad_y

	move_and_slide()

	if preparando_pateo:
		timer_preparacion += delta
		if timer_preparacion >= tiempo_preparacion:
			patear_pelota()
			tiempo_ultimo_pateo = 0.0
			preparando_pateo = false

func patear_pelota():
	if not pelota or not arco_enemigo:
		return

	var dir = (arco_enemigo.global_transform.origin - pelota.global_transform.origin).normalized()
	dir.y = 0.2
	var impulso = dir * fuerza_pateo

	pelota.apply_central_impulse(impulso)
