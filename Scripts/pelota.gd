extends RigidBody3D

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node) -> void:
	print("Colisión con:", body.name)  

	if body is StaticBody3D and body.name.begins_with("Bloque"):
		body.queue_free()
