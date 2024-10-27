extends StateMachineState
class_name PlayerState

@export var state_effects : CreateEffects
@onready var player = get_owner() as Player
@export var can_crouch_in_this_state : bool = true
var snap_margin = 0.01
var is_player_on_stairs : bool = false

var created_effects : Array[Effect]

func on_enter():
	if state_effects:
		created_effects = state_effects.add_effects(player)

func on_exit():
	if not created_effects.is_empty():
		for effect in created_effects:
			effect.discard_effects()


func handle_run() -> void:
	if Input.is_action_pressed("sprint"):
		if player.can_run():
			change_state("Run")


func catch_movement() -> void:
	if player.is_multiplayer_authority():
		if Input.is_action_pressed("move_backward") or Input.is_action_pressed("move_forward") or \
		Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
			change_state("Walk")

func catch_no_movement() -> void:
	if player.velocity.is_equal_approx(Vector3.ZERO):
		change_state("Idle")

func handle_movement(delta) -> void:
	var input_dir : Vector2
	if player.is_multiplayer_authority():
		input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = input_dir.rotated(-player.rotation.y)
	direction = Vector3(direction.x, 0, direction.y)
	var _dot = direction.dot(-player.global_transform.basis.z)
	var _dot_p = _dot * 0.25 + 0.85
	_dot_p = clamp(_dot_p, 0, 1)
	var total_speed = player.stats.speed
	player.velocity.x = lerp(player.velocity.x, direction.x * total_speed * _dot_p, player.stats.acceleration * delta)
	player.velocity.z = lerp(player.velocity.z, direction.z * total_speed * _dot_p, player.stats.acceleration * delta)
	if direction.is_equal_approx(Vector3.ZERO) and (state_machine.current_state.name == "Walk"\
	or state_machine.current_state.name == "Run"):
		change_state("Idle")
	player.move_and_slide()


func slopes_and_stairs(delta) -> void:
	if player.legs.is_on_slope():
		snap_to_floor(delta)
		#%Label5.text = "slopes!"
		is_player_on_stairs = false
	
	elif player.legs.is_on_stairs():
		handle_stairs(delta)
		#%Label5.text = "stairs!"
		is_player_on_stairs = true
	
	elif not player.legs.is_stairs_beneath():
		snap_to_floor(delta)
		is_player_on_stairs = false
		

func snap_to_floor(delta) -> void:
	if player.legs.is_ray_floor() and player.velocity.y >= 0:
		player.global_position.y = player.legs.get_floor_point().y - snap_margin

func handle_stairs(delta) -> void:
	var _point = player.legs.get_staircase_point()
	if player.head.head_free_space():
		if not _point.is_equal_approx(Vector3.ZERO):
			player.global_position.y = _point.y - snap_margin

func handle_no_floor() -> void:
	if not player.legs.is_ray_floor():
		change_state("Air")

func handle_fall(delta) -> void:
	player.velocity.y -= player.stats.gravity * delta


func smooth_landing(delta) -> void:
	if player.velocity.y > 0:
		player.velocity.y = -0.01
	if player.velocity.y <= 0:
		player.velocity.y = lerp(player.velocity.y, 0.0, delta)

func handle_crouch() -> void:
	if player.is_multiplayer_authority():
		if Input.is_action_just_pressed("crouch"):
			if can_crouch_in_this_state:
				change_state("Crouch")

# TODO: заменить твин камеры на полноценную анимацию.
func tween_camera_crouch() -> void:
	var _tween := create_tween()
	var _position : float = 0.55
	var _time : float = 0.32
	_tween.tween_property(player.head, "position:y", _position, _time)
	_tween.play()
	await  _tween.finished
	_tween.kill()
	
func tween_camera_uncrouch() -> void:
	var _tween := create_tween()
	var _position : float = 1.5
	var _time : float = 0.41
	_tween.tween_property(player.head, "position:y", _position, _time)
	_tween.play()
	await  _tween.finished
	_tween.kill()

func handle_uncrouch() -> void:
	if player.is_multiplayer_authority():
		if Input.is_action_just_pressed("uncrouch") or Input.is_action_just_pressed("jump"):
			if player.head.head_free_space():
				change_state("Walk")
