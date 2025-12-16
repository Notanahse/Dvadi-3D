extends Control

@onready var boton_river = $River
@onready var boton_boca = $Boca
@onready var boton_independiente = $Independiente
@onready var boton_racing = $Racing
@onready var boton_sanlorenzo = $SanLorenzo
@onready var boton_poli = $Poli
@onready var boton_velez = $Velez
@onready var boton_huracan=$Huracan
@onready var escudo_preview = $EscudoPreview  

func _ready():
	var nodos = [
		"River", "Boca", "Independiente", "Racing",
		"SanLorenzo", "Poli", "Velez", "Huracan"
	]

	for n in nodos:
		if not has_node(n):
			print("ERROR: No existe el nodo: ", n)
		else:
			print("OK nodo: ", n)

	boton_river.pressed.connect(func(): seleccionar_equipo("River"))
	boton_boca.pressed.connect(func(): seleccionar_equipo("Boca"))
	boton_independiente.pressed.connect(func(): seleccionar_equipo("Independiente"))
	boton_racing.pressed.connect(func(): seleccionar_equipo("Racing"))
	boton_sanlorenzo.pressed.connect(func(): seleccionar_equipo("SanLorenzo"))
	boton_poli.pressed.connect(func(): seleccionar_equipo("Poli"))
	boton_velez.pressed.connect(func(): seleccionar_equipo("Velez"))
	boton_huracan.pressed.connect(func(): seleccionar_equipo("Huracan"))


func seleccionar_equipo(nombre_equipo: String):
	Global.equipo_seleccionado = nombre_equipo
	Global.skin_jugador = Global.escudos[nombre_equipo] 

	call_deferred("_ir_a_torneo")


func _ir_a_torneo():
	get_tree().change_scene_to_file("res://MenuTorneo.tscn")

func mostrar_escudo(nombre_equipo: String):
	var ruta = "res://escudos/%s.png" % nombre_equipo

	if FileAccess.file_exists(ruta):
		escudo_preview.texture = load(ruta)
	else:
		print("NO SE ENCONTRÓ EL ESCUDO:", ruta)

func _ir_a_octavos():
	get_tree().change_scene_to_file("res://MenuTorneo.tscn")
