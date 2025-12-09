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

var joy2 := -1
var velocidad_cursor := 900.0
var deadzone := 0.25

func _ready():
	var pads = Input.get_connected_joypads()
	if pads.size() > 0:
		joy2 = pads[0]

	buttons = get_tree().get_nodes_in_group("seleccion_Equipo")

	cursor1.visible = true
	cursor2.visible = true


func _process(delta):
	cursor1.position = get_viewport().get_mouse_position()

	if joy2 != -1:
		var x := Input.get_joy_axis(joy2, JOY_AXIS_LEFT_X)
		var y := Input.get_joy_axis(joy2, JOY_AXIS_LEFT_Y)

		if abs(x) < deadzone: x = 0
		if abs(y) < deadzone: y = 0

		cursor2.position += Vector2(x, y) * velocidad_cursor * delta

		cursor2.position.x = clamp(cursor2.position.x, 0, get_viewport_rect().size.x)
		cursor2.position.y = clamp(cursor2.position.y, 0, get_viewport_rect().size.y)

		if Input.is_joy_button_pressed(joy2, JOY_BUTTON_A):
			seleccionar_cursor(cursor2, 2)

	if Input.is_action_just_pressed("click"):
		seleccionar_cursor(cursor1, 1)


func seleccionar_cursor(cursor: Control, jugador: int):
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
			return

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Nivel.tscn")
