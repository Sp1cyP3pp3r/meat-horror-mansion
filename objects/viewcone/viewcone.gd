extends Area3D
class_name Viewcone

@export var collision : CollisionShape3D
@export var ray : RayCast3D
@export var view_range : float = 1
@export var view_clearance : float = 100

var seen_entities : Array[Player] = []
var sees_player : bool = false

signal see_enemy(enemy : CharacterBody3D)
signal lost_enemy(enemy : CharacterBody3D)

func _ready() -> void:
	update_collider(view_range)

func _physics_process(delta: float) -> void:
	if not seen_entities.is_empty():
		#for entity in seen_entities:
			var entity = seen_entities[0]
			var c_pos = entity.head.camera.global_position - Vector3(0, 0.1, 0)
			var dir = global_position.direction_to(c_pos)
			var dist = global_position.distance_to(c_pos)
			var t_pos = dir * dist * global_basis.orthonormalized()
			var focus_speed = view_clearance
			
			ray.target_position = lerp(ray.target_position, t_pos, delta * focus_speed)
			
			if ray.is_colliding():
				sees_player = false
				lost_enemy.emit(entity)
			else:
				var light = owner.player.get_light_level()
				var view = view_clearance
				if light > view:
					sees_player = false
				else:
					sees_player = true
					see_enemy.emit(entity)
	else:
		sees_player = false

func add_seen_entity(entity):
	if not entity in seen_entities:
		seen_entities.append(entity)

func remove_seen_entity(entity):
	if entity in seen_entities:
		seen_entities.erase(entity)

func update_collider(value):
	var points : Array[Vector3] = [
		Vector3(0, 0, 0),
		Vector3(-1, -1, -1),
		Vector3(1, -1, -1),
		Vector3(-1, 1, -1),
		Vector3(1, 1, -1),
		]
	
	var i = 0
	for point in points:
		points[i] = point * value
		i += 1
	
	collision.shape.points = points.duplicate()
