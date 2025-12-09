extends Control


func _on_jugar_pressed() -> void:
	get_tree().change_scene_to_file("res://MenuEquipos.tscn")


func _on_salir_pressed() -> void:
	get_tree().quit()


func _on_multijugador_pressed() -> void:
	get_tree().change_scene_to_file("res://Escenas/menu_multiplayer.tscn")
