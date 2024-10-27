extends RayCast3D

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Interact"):
		if is_colliding():
			var obj = get_collider()
			if obj.has_method(&"interact"):
				obj.interact()
