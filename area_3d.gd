extends Area3D

@export var equipo = "Bot"
var goles = 0

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body is RigidBody3D and body.name == "Pelota":
		goles += 1
		reiniciar_pelota(body)

func reiniciar_pelota(pelota: RigidBody3D):
	pelota.global_transform.origin = Vector3(-2, 7, -15)
	pelota.linear_velocity = Vector3.ZERO
	pelota.angular_velocity = Vector3.ZERO
