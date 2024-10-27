extends CharacterBody3D
class_name Player

signal entity_death()

@export_category("Bodyparts")
@export var legs : Node3D
@export var head : Node3D
@export var health : Health

@export var stats : Dictionary[String, float] = {
	speed = 5, #2.25,
	max_hp = 100.0,
	acceleration = 18.0,
	gravity = 15.0,
	damage_susceptibility = 0,
	damage_resistance = 0,
	healing_susceptibility = 0,
	healing_resistance = 0
}


@onready var state_machine = %FiniteStateMachine

var additional_velocity : Vector3 :
	set(val):
		if val.is_equal_approx(Vector3.ZERO):
			additional_velocity = Vector3.ZERO
		else:
			additional_velocity = val

func _physics_process(delta: float) -> void:
	var pre_velocity = velocity
	velocity = pre_velocity + additional_velocity
	
func get_light_level() -> float:
	return %LightDetector.light_level

func death(killer = self):
	entity_death.emit(self)
	
func can_run() -> bool:
	if Input.is_action_pressed("move_backward"):
		return false
	return true
