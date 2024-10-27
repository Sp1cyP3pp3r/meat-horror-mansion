extends Node3D
class_name Last

@onready var ray: RayCast3D = $PlayerLastRay

@export var ray_length : float = 30

func get_hit_ray():
	var c_pos = owner.last_velocity
	var dir = global_position.direction_to(global_position + c_pos)
	var t_pos = dir * ray_length * global_basis.orthonormalized()
	ray.target_position = t_pos
	ray.force_raycast_update()
	if ray.is_colliding():
		return ray.get_collision_point()
	return false
