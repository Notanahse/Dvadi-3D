extends Node3D

@onready var areaA = $StaticBody3D/Area3D
@onready var areaB = $StaticBody3D2/Area3D
@onready var label1 = $CanvasLayer/Label
@onready var label2 = $CanvasLayer/Label2
@onready var label_tiempo = $CanvasLayer/LabelTiempo 
@onready var jugador = $SubViewportContainer/SubViewport/JugadorTeclado2           
@onready var jugador2 = $SubViewportContainer2/SubViewport/JugadorTeclado                      
@onready var pelota = $Pelota   
var tiempo_transcurrido = 0.0
var duracion_partido = 60.0  
var en_gol_de_oro = false
var juego_terminado = false
var golesA_anteriores = 0
var golesB_anteriores = 0
func _ready():
	label_tiempo.text = "00:00"


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


	if golesA > golesB:
		get_tree().change_scene_to_file("res://MenuFin.tscn")
	elif golesB > golesA:
		get_tree().change_scene_to_file("res://MenuFin.tscn")

func reset_jugadores():
	jugador.global_transform.origin = Vector3(-1, 0, 0)
	jugador2.global_transform.origin = Vector3(-1, 0, -30)
