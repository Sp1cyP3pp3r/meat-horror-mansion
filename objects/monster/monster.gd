extends CharacterBody3D
class_name Monster

@export var nav_agent : NavigationAgent3D
@export var player : Player

@onready var player_last = $PlayerLast
@onready var eyes = $Eyes

@export var stats : Dictionary[String, float] = {
	"speed" : 4.0,
	"acceleration" : 30.0,
	"gravity" : 18
}
var is_on_stairs
var nav_target : Vector3
var fail_safe_target : Vector3
var interrupt : bool = false
var last_seen_point : Vector3
var last_velocity : Vector3

func _ready() -> void:
	fail_safe_target = global_position

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= stats.gravity
	else:
		velocity.y = 0
	var destination = nav_agent.get_next_path_position()
	var local_destination = destination - global_position
	var direction = local_destination.normalized()
	var total_speed = stats.speed
	velocity.x = lerp(velocity.x, direction.x * total_speed, stats.acceleration * delta)
	velocity.z = lerp(velocity.z, direction.z * total_speed, stats.acceleration * delta)
	nav_agent.set_velocity(velocity)
	
	look_at(global_position + direction)
	rotation.x = 0
	rotation.z = 0
	
	move_and_slide()
	


func start_navigation():
	nav_agent.target_position = nav_target

func end_navigation():
	pass


func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = safe_velocity
