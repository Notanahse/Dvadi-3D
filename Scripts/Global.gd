extends Node

var equipos_torneo = [
	"River","Boca","Independiente","Racing",
	"SanLorenzo","Poli","Velez","Huracan"
]

var equipo_seleccionado : String = ""
var rival_seleccionado  : String = ""
var ronda_actual : String = "cuartos"


var cruces = {
	"cuartos": [],
	"semis": [],
	"final": []
}

# Escudos para UI
var escudos := {
	"River": preload("res://Escudos/River.png"),
	"Boca": preload("res://Escudos/Boca.png"),
	"Independiente": preload("res://Escudos/Independiente.png"),
	"Racing": preload("res://Escudos/Racing.png"),
	"SanLorenzo": preload("res://Escudos/SanLorenzo.png"),
	"Poli": preload("res://Escudos/Poli.png"),
	"Velez": preload("res://Escudos/Velez.png"),
	"Huracan": preload("res://Escudos/Huracan.png")
}

var skin_jugador : Texture2D = null
var skin_rival : Texture2D = null

# Reset del torneo
func reset_torneo():
	ronda_actual = "cuartos"
	for key in cruces.keys():
		cruces[key].clear()


func generar_cruces():
	reset_torneo()
	var mezcla = equipos_torneo.duplicate()
	mezcla.shuffle()
	for i in range(0, mezcla.size(), 2):
		cruces["cuartos"].append({"equipo1": mezcla[i], "equipo2": mezcla[i+1], "ganador": null})


func simular_partido(e1:String, e2:String) -> String:
	return [e1, e2].pick_random()

func simular_ronda(ronda:String):
	for cruce in cruces[ronda]:
		if cruce["ganador"] == null and not [cruce["equipo1"], cruce["equipo2"]].has(equipo_seleccionado):
			cruce["ganador"] = simular_partido(cruce["equipo1"], cruce["equipo2"])

func agregar_resultado_real(ronda:String, equipo_ganador:String):
	for cruce in cruces[ronda]:
		if [cruce["equipo1"], cruce["equipo2"]].has(equipo_seleccionado):
			cruce["ganador"] = equipo_ganador
			break

func obtener_cruce_activo(ronda:String) -> Dictionary:
	for cruce in cruces[ronda]:
		if [cruce.get("equipo1", ""), cruce.get("equipo2", "")].has(equipo_seleccionado) \
		and cruce.get("ganador", null) == null:
			return cruce
	return {}


func generar_siguiente_ronda(ronda_origen:String, ronda_destino:String):
	cruces[ronda_destino].clear()
	var prev = cruces[ronda_origen]

	for i in range(0, prev.size(), 2):
		if i + 1 >= prev.size():
			continue

		var cruce1 = prev[i]
		var cruce2 = prev[i+1]

		if cruce1["ganador"] != null and cruce2["ganador"] != null:
			cruces[ronda_destino].append({
				"equipo1": cruce1["ganador"],
				"equipo2": cruce2["ganador"],
				"ganador": null
			})
