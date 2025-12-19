extends Control


func _on_jugar_pressed() -> void:
	get_tree().change_scene_to_file("res://MEnuSeleccionMultijugador.tscn")


func _on_atras_pressed() -> void:
	get_tree().change_scene_to_file("res://Menu.tscn")
