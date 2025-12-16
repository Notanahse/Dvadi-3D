extends Node

@onready var escudo_jugador = $EscudoJugador
@onready var escudo_rival = $EscudoRival
@onready var boton_jugar = $VBoxContainer2/Jugar

func _ready():
	# Si no existen cruces, los generamos UNA VEZ aquí
	if Global.cruces["cuartos"].is_empty():
		Global.generar_cruces()
		# Simular los partidos de cuartos que no involucren al jugador
		Global.simular_ronda("cuartos")
		# No generamos semis/final aún: se generarán cuando el jugador juegue su cruce y se actualicen los ganadores.

	mostrar_cruce_actual()
	if boton_jugar:
		boton_jugar.pressed.connect(_jugar_partido)

func mostrar_cruce_actual():
	var jugador = Global.equipo_seleccionado

	# Buscar el cruce donde está el jugador en cuartos (si existe)
	for cruce in Global.cruces["cuartos"]:
		if cruce.get("equipo1", "") == jugador:
			Global.rival_seleccionado = cruce.get("equipo2", "")
		elif cruce.get("equipo2", "") == jugador:
			Global.rival_seleccionado = cruce.get("equipo1", "")

	Global.skin_rival = Global.escudos.get(Global.rival_seleccionado, null)

	escudo_jugador.texture = Global.escudos.get(Global.equipo_seleccionado, null)
	escudo_rival.texture = Global.escudos.get(Global.rival_seleccionado, null)

func _jugar_partido():
	# Establecer ronda actual a cuartos si se va a jugar la primera fase
	Global.ronda_actual = "cuartos"
	get_tree().change_scene_to_file("res://NivelBot.tscn")
