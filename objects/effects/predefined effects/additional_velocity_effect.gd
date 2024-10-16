extends Effect

@export var velocity_power : float
@export var velocity_direction : Vector3 :
	set(param):
		velocity_direction = param.normalized()

@export var apply_additional_up_velocity : bool = false
var velocity

func apply_predesigned_effect() -> void:
	await ready
	velocity = velocity_direction * velocity_power
	
	if apply_additional_up_velocity:
		velocity += Vector3.UP
	
	if "additional_velocity" in effected_game_object:
		print("the AV: " + str(effected_game_object.additional_velocity) + "\n")
		effected_game_object.additional_velocity += velocity
		print("the Velocity: " + str(velocity))
		print("the AV: " + str(effected_game_object.additional_velocity) + "\n")
	else:
		print("doesn't apply")
		discard_effects()

func discard_predesigned_effects() -> void:
	if "additional_velocity" in effected_game_object:
		effected_game_object.additional_velocity -= velocity
		print("the Minus Velocity: " + str(velocity))
		print("the AV: " + str(effected_game_object.additional_velocity) + "\n")
