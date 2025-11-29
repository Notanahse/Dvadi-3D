extends Control

@onready var boton_river = $River
@onready var boton_boca = $Boca
@onready var boton_independiente = $Independiente
@onready var boton_racing = $Racing
@onready var boton_sanlorenzo = $SanLorenzo
@onready var boton_poli = $Poli
@onready var escudo_preview = $EscudoPreview  

func _ready():
	boton_river.pressed.connect(func(): seleccionar_equipo("River"))
	boton_boca.pressed.connect(func(): seleccionar_equipo("Boca"))
	boton_independiente.pressed.connect(func(): seleccionar_equipo("Independiente"))
	boton_racing.pressed.connect(func(): seleccionar_equipo("Racing"))
	boton_sanlorenzo.pressed.connect(func(): seleccionar_equipo("SanLorenzo"))
	boton_poli.pressed.connect(func(): seleccionar_equipo("Poli"))



func seleccionar_equipo(nombre_equipo: String):
	print("Equipo seleccionado:", nombre_equipo)
	Global.equipo_seleccionado = nombre_equipo

	mostrar_escudo(nombre_equipo)

	call_deferred("_ir_a_octavos")

func mostrar_escudo(nombre_equipo: String):
	var ruta = "res://escudos/%s.png" % nombre_equipo

	if FileAccess.file_exists(ruta):
		escudo_preview.texture = load(ruta)
	else:
		print("NO SE ENCONTRÓ EL ESCUDO:", ruta)

func _ir_a_octavos():
	get_tree().change_scene_to_file("res://MenuTorneo.tscn")
