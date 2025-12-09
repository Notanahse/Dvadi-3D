extends Camera3D

@export var target: Node3D   

func _process(delta):
	if not target: return
	look_at(target.global_transform.origin, Vector3.UP)
