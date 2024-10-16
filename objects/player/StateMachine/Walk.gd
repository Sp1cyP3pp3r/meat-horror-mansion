extends PlayerState


func on_physics_process(delta):
	handle_movement(delta)
	handle_no_floor()
	slopes_and_stairs(delta)
	catch_no_movement()
	smooth_landing(delta)
	handle_crouch()
	handle_run()
