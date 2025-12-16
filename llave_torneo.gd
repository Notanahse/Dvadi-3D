extends Control

@onready var cuar_nodes = [
	$Cuartos/cuar1, $Cuartos/cuar2,
	$Cuartos/cuar3, $Cuartos/cuar4,
	$Cuartos/cuar5, $Cuartos/cuar6,
	$Cuartos/cuar7, $Cuartos/cuar8
]

@onready var semi_nodes = [
	$Semis/semis1, $Semis/semis2,
	$Semis/semis3, $Semis/semis4
]

@onready var final1 = $Final/Final1
@onready var final2 = $Final/Final2
@onready var campeao = $Final/Campeao

@onready var boton_jugar = $Button

func _ready():
	
	mostrar_cuartos()
	mostrar_semis()
	mostrar_final()

	# Conectar la señal por si no se conectó desde el editor
	if boton_jugar and not boton_jugar.is_connected("pressed", Callable(self, "_on_button_pressed")):
		boton_jugar.pressed.connect(_on_button_pressed)

	_actualizar_estado_boton()

func mostrar_cuartos():
	var index = 0
	for cruce in Global.cruces["cuartos"]:
		var e1 = cruce.get("equipo1", null)
		var e2 = cruce.get("equipo2", null)

		# seguridad: no indexar fuera del array de nodos
		if index >= cuar_nodes.size():
			break

		if cuar_nodes[index] and e1 != null:
			cuar_nodes[index].texture = Global.escudos.get(e1, null)
		if index + 1 < cuar_nodes.size() and cuar_nodes[index+1] and e2 != null:
			cuar_nodes[index+1].texture = Global.escudos.get(e2, null)

		index += 2

func mostrar_semis():
	var index = 0
	for cruce in Global.cruces["semis"]:
		var e1 = cruce.get("equipo1", null)
		var e2 = cruce.get("equipo2", null)

		if index >= semi_nodes.size():
			break

		if semi_nodes[index] and e1 != null:
			semi_nodes[index].texture = Global.escudos.get(e1, null)
		if index + 1 < semi_nodes.size() and semi_nodes[index+1] and e2 != null:
			semi_nodes[index+1].texture = Global.escudos.get(e2, null)

		index += 2

func mostrar_final():
	if Global.cruces["final"].size() > 0:
		var cruce_final = Global.cruces["final"][0]
		if cruce_final.has("equipo1"):
			final1.texture = Global.escudos.get(cruce_final["equipo1"], null)
		if cruce_final.has("equipo2"):
			final2.texture = Global.escudos.get(cruce_final["equipo2"], null)
		campeao.texture = Global.escudos.get(cruce_final.get("ganador", null), null) if cruce_final.get("ganador", null) != null else null



func _tiene_cruce_activo(ronda:String) -> bool:
	var cruce = Global.obtener_cruce_activo(ronda)

	return not cruce.is_empty()

func _obtener_rival_de_cruce_activo(ronda:String) -> String:
	var cruce = Global.obtener_cruce_activo(ronda)
	if cruce.is_empty():
		return ""

	if cruce.get("equipo1", "") == Global.equipo_seleccionado:
		return cruce.get("equipo2", "")
	else:
		return cruce.get("equipo1", "")

func _definir_proximo_rival() -> Dictionary:

	if _tiene_cruce_activo("semis"):
		return {"rival": _obtener_rival_de_cruce_activo("semis"), "ronda": "semis"}
	if _tiene_cruce_activo("final"):
		return {"rival": _obtener_rival_de_cruce_activo("final"), "ronda": "final"}

	return {}

func _actualizar_estado_boton():

	var habilitar = _tiene_cruce_activo("semis") or _tiene_cruce_activo("final")
	if boton_jugar:
		boton_jugar.disabled = not habilitar


func refrescar_llave():
	mostrar_cuartos()
	mostrar_semis()
	mostrar_final()
	_actualizar_estado_boton()


func _on_button_pressed() -> void:
	var info = _definir_proximo_rival()
	if info.is_empty():

		print("No hay próximo rival (semis/final no disponibles).")
		if boton_jugar:
			boton_jugar.disabled = true
		return

	var rival = info["rival"]
	var ronda = info["ronda"]


	print("Botón presionado -> Ronda:", ronda, "Rival:", rival)


	Global.rival_seleccionado = rival
	Global.skin_rival = Global.escudos.get(rival, null)
	Global.skin_jugador = Global.escudos.get(Global.equipo_seleccionado, null)
	Global.ronda_actual = ronda

	get_tree().change_scene_to_file("res://NivelBot.tscn")
