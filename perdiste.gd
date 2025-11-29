extends Control

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_jugar_pressed() -> void:
	get_tree().change_scene_to_file("res://Nivel.tscn")

func _on_atras_pressed() -> void:
	get_tree().change_scene_to_file("res://Menu.tscn")
