extends PlayerState


# Called when the state machine enters this state.
func on_enter():
	super()
	%CrouchCollision.disabled = false
	%StandCollision.disabled = true
	tween_camera_crouch()
	vinnete_start()

# Called every physics frame when this state is active.
func on_physics_process(delta):
	handle_movement(delta)
	handle_no_floor()
	slopes_and_stairs(delta)
	handle_uncrouch()
	smooth_landing(delta)


# Called when the state machine exits this state.
func on_exit():
	super()
	tween_camera_uncrouch()
	player.head.head_free_space_cast.target_position.y = 0.9
	vinnete_end()
	%CrouchCollision.disabled = true
	%StandCollision.disabled = false

func vinnete_start():
	var tween = create_tween()
	tween.tween_property(%CrouchVinette, "modulate", Color(Color.WHITE, 1), 0.5)
	tween.play()
	await tween.finished
	tween.kill()


func vinnete_end():
	var tween = create_tween()
	tween.tween_property(%CrouchVinette, "modulate", Color(Color.WHITE, 0), 0.6)
	tween.play()
	await tween.finished
	tween.kill()

func change_state(state : String, ):
	if player.head.head_free_space():
		super(state)
