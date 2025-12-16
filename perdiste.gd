extends Control

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_jugar_pressed() -> void:
	Global.rival_seleccionado = ""
	Global.ronda_actual = ""
	get_tree().change_scene_to_file("res://MenuEquipos.tscn")

func _on_atras_pressed() -> void:
	Global.rival_seleccionado = ""
	Global.equipo_seleccionado = ""
	Global.ronda_actual = ""
	get_tree().change_scene_to_file("res://Menu.tscn")
