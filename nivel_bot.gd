extends Node3D

@onready var areaA = $StaticBody3D/Area3D      
@onready var areaB = $StaticBody3D2/Area3D   
@onready var label1 = $CanvasLayer/Label
@onready var label2 = $CanvasLayer/Label2
@onready var label_tiempo = $CanvasLayer/LabelTiempo 

@onready var jugador = $Jugador            
@onready var bot = $Bot                      
@onready var pelota = $Pelota               

var tiempo_transcurrido = 0.0
var duracion_partido = 60.0  
var en_gol_de_oro = false
var juego_terminado = false

var golesA_anteriores = 0
var golesB_anteriores = 0

func _ready():
	label_tiempo.text = "00:00"
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	# Asegúrate de que Global.rival_seleccionado esté seteado antes de empezar (lo hace llave_torneo o menu_torneo)

func _physics_process(delta):
	if juego_terminado:
		return

	var golesA = areaA.getGoles()
	var golesB = areaB.getGoles()

	if golesA > golesA_anteriores:
		reset_jugadores()
		golesA_anteriores = golesA

	if golesB > golesB_anteriores:
		reset_jugadores()
		golesB_anteriores = golesB

	label1.text = str(golesA)
	label2.text = str(golesB)

	if not en_gol_de_oro:
		tiempo_transcurrido += delta
		if tiempo_transcurrido >= duracion_partido:
			tiempo_transcurrido = duracion_partido
			verificar_resultado_final()
	else:
		if golesA != golesB:
			mostrar_resultado(golesA, golesB)

	actualizar_label_tiempo()

func actualizar_label_tiempo():
	var minutos = int(tiempo_transcurrido / 60)
	var segundos = int(tiempo_transcurrido) % 60
	label_tiempo.text = str(minutos).pad_zeros(2) + ":" + str(segundos).pad_zeros(2)

func verificar_resultado_final():
	var golesA = areaA.getGoles()
	var golesB = areaB.getGoles()

	if golesA == golesB:
		en_gol_de_oro = true
		label_tiempo.text = "gol de oro"
	else:
		mostrar_resultado(golesA, golesB)

func mostrar_resultado(golesA, golesB):
	juego_terminado = true
	label_tiempo.text = "terminado"
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	# IMPORTANTE: en tu código original considerabas que si golesB > golesA el jugador ganaba.
	# Mantengo esa lógica pero la generalizo usando Global.ronda_actual.
	# Si en tu caso el jugador pertenece a areaA/areaB distinto, ajusta las comparaciones.
	if golesA > golesB:
		# Ganó A -> asumo que A es el rival (ajusta si es al revés)
		var ganador = Global.rival_seleccionado
		# Registrar ganador en la ronda actual
		Global.agregar_resultado_real(Global.ronda_actual, ganador)
		# No generamos la siguiente ronda desde aquí si perdiste, pero podrías querer hacerlo.
		get_tree().change_scene_to_file("res://Perdiste.tscn")

	elif golesB > golesA:
		# Ganó B -> asumimos que B es el jugador (como en tu código original)
		var ganador_jugador = Global.equipo_seleccionado
		Global.agregar_resultado_real(Global.ronda_actual, ganador_jugador)

		# Generar la siguiente ronda y simular aquellos partidos que no involucren al jugador
		if Global.ronda_actual == "cuartos":
			Global.generar_siguiente_ronda("cuartos", "semis")
			# Simular semis (la función evita simular el cruce del jugador)
			Global.simular_ronda("semis")
			# Preparar la generación de la final (se generará si hay ganadores en semis)
			Global.generar_siguiente_ronda("semis", "final")

		elif Global.ronda_actual == "semis":
			Global.generar_siguiente_ronda("semis", "final")
			Global.simular_ronda("final")

		elif Global.ronda_actual == "final":
			# Si era la final, el cruce final ya tiene el ganador seteado
			# Podrías mostrar una pantalla de "Campeón"
			pass

		# Volver a la llave para mostrar el estado actualizado
		get_tree().change_scene_to_file("res://llave_torneo.tscn")

func reset_jugadores():
	jugador.global_transform.origin = Vector3(-1, 0, 0)
	bot.global_transform.origin = Vector3(-1, 0, -30)
