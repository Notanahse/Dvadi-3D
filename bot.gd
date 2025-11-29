extends CharacterBody3D

@export var velocidad_base = 6.0
@export var fuerza_pateo_base = 20.0
@export var velocidad_giro_base = 15.0
@export var pelota: RigidBody3D
@export var arco_enemigo: StaticBody3D

var velocidad = 6.0
var fuerza_pateo = 20.0
var velocidad_giro = 15.0

var velocidad_y = 0.0
@export var gravedad = 30.0

var tiempo_ultimo_pateo = 0.0
@export var cooldown_pateo = 1.0
@export var tiempo_preparacion = 0.5
var preparando_pateo = false
var timer_preparacion = 0.0

@export var distancia_para_patear = 1.1

@onready var mesh = $MeshInstance3D

func _ready():
	if Global.skin_rival != null:
		aplicar_skin(Global.skin_rival)
	else:
		print("No se cargó Global.skin_rival")

	ajustar_dificultad()


func aplicar_skin(textura):
	if mesh == null:
		print("No se encontró MeshInstance3D en el bot")
		return

	var material = mesh.get_surface_override_material(0)

	if material == null:
		material = StandardMaterial3D.new()
		mesh.set_surface_override_material(0, material)

	material.albedo_texture = textura



func ajustar_dificultad():
	match Global.ronda_actual:
		"octavos":
			velocidad = velocidad_base
			fuerza_pateo = fuerza_pateo_base
			velocidad_giro = velocidad_giro_base
		"cuartos":
			velocidad = velocidad_base * 1.2
			fuerza_pateo = fuerza_pateo_base * 2.0
			velocidad_giro = velocidad_giro_base * 1.1
		"semis":
			velocidad = velocidad_base * 1.6
			fuerza_pateo = fuerza_pateo_base * 2.6
			velocidad_giro = velocidad_giro_base * 1.3
		"final":
			velocidad = velocidad_base * 1.8
			fuerza_pateo = fuerza_pateo_base * 3
			velocidad_giro = velocidad_giro_base * 1.4

	print("Bot ajustado: Ronda %s | Vel: %.2f | Fuerza: %.2f | Giro: %.2f" %
		[Global.ronda_actual, velocidad, fuerza_pateo, velocidad_giro])


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
