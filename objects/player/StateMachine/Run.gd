extends PlayerState


func on_physics_process(delta):
	handle_movement(delta)
	handle_no_floor()
	slopes_and_stairs(delta)
	catch_no_movement()
	smooth_landing(delta)
	handle_crouch()
	
	handle_run_end()


func handle_run_end():
	if Input.is_action_just_released("sprint") or Input.is_action_pressed("move_backward"):
		change_state("Walk")
