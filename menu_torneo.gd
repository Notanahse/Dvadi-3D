extends Control

func _ready():

	if Global.ronda_actual == "":
		Global.ronda_actual = "octavos"


	actualizar_titulo()


	if Global.equipo_seleccionado == "":
		print("no hay equipo seleccionado")
		return


	if Global.rival_seleccionado == "":
		Global.rival_seleccionado = generar_rival()

	mostrar_equipos()
	asignar_skins()


func actualizar_titulo():
	match Global.ronda_actual:
		"octavos":
			$VBoxContainer/Titulo.text = "OCTAVOS DE FINAL"
		"cuartos":
			$VBoxContainer/Titulo.text = "CUARTOS DE FINAL"
		"semis":
			$VBoxContainer/Titulo.text = "SEMIFINAL"
		"final":
			$VBoxContainer/Titulo.text = "FINAL"
		_:
			$VBoxContainer/Titulo.text = "TORNEO"


func generar_rival():
	var equipos = ["River", "Boca", "Independiente", "Racing", "SanLorenzo", "Poli"]


	equipos.erase(Global.equipo_seleccionado)

	for e in Global.rivales_jugados:
		if equipos.has(e):
			equipos.erase(e)


	if equipos.size() == 0:
		return "Poli" 

	var rival = equipos[randi() % equipos.size()]

	Global.rivales_jugados.append(rival)

	Global.skin_rival = load("res://Escudos/%s.png" % rival)

	return rival


func mostrar_equipos():
	var escudo_j = load("res://Escudos/%s.png" % Global.equipo_seleccionado)
	var escudo_r = load("res://Escudos/%s.png" % Global.rival_seleccionado)

	$EscudoJugador.texture = escudo_j
	$EscudoRival.texture = escudo_r


func asignar_skins():
	if Global.skin_jugador == null:
		Global.skin_jugador = load("res://Escudos/%s.png" % Global.equipo_seleccionado)


func _on_jugar_pressed():
	get_tree().change_scene_to_file("res://NivelBot.tscn")
