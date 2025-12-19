extends Control

@onready var cursor1 = $Cursor1
@onready var cursor2 = $Cursor2

@onready var buttons := []
@onready var EscudoJ1 = $TextureRect/EscudoJugador
@onready var EscudoJ2 = $TextureRect/EscudoRival

const Equipos := {
	"River": "res://Escudos/River.png",
	"Boca": "res://Escudos/Boca.png",
	"Independiente": "res://Escudos/Independiente.png",
	"Racing": "res://Escudos/Racing.png",
	"SanLorenzo": "res://Escudos/SanLorenzo.png",
	"Poli": "res://Escudos/Poli.png",
	"Velez": "res://Escudos/Velez.png",
	"Huracan": "res://Escudos/Huracan.png"
}

enum Turno { JUGADOR_1, JUGADOR_2 }
var turno_actual := Turno.JUGADOR_1


func _ready():
	buttons = get_tree().get_nodes_in_group("seleccion_Equipo")

	cursor1.visible = true
	cursor2.visible = false   


func _process(delta):
	var mouse_pos := get_viewport().get_mouse_position()

	if turno_actual == Turno.JUGADOR_1:
		cursor1.position = mouse_pos

		if Input.is_action_just_pressed("click"):
			if seleccionar_cursor(cursor1, 1):
				turno_actual = Turno.JUGADOR_2
				cursor1.visible = false
				cursor2.visible = true

	elif turno_actual == Turno.JUGADOR_2:
		cursor2.position = mouse_pos

		if Input.is_action_just_pressed("click"):
			if seleccionar_cursor(cursor2, 2):
				print("Ambos equipos seleccionados")



func seleccionar_cursor(cursor: Control, jugador: int) -> bool:
	for b in buttons:
		if cursor.get_global_rect().intersects(b.get_global_rect()):
			if Equipos.has(b.name):
				if jugador == 1:
					EscudoJ1.texture = load(Equipos[b.name])
					Global.equipo_seleccionado = b.name
					Global.skin_jugador = load(Equipos[b.name])
				else:
					EscudoJ2.texture = load(Equipos[b.name])
					Global.rival_seleccionado = b.name
					Global.skin_rival = load(Equipos[b.name])



	return false

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://NivelTeclado.tscn")
