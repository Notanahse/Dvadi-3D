extends Control



func _on_mando_pressed() -> void:
	get_tree().change_scene_to_file("res://Escenas/menu_multiplayer.tscn")
	


func _on_teclado_pressed() -> void:
	get_tree().change_scene_to_file("res://MenuSeleccionEquiposMouse.tscn")
