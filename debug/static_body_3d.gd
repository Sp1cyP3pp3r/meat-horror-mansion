extends StaticBody3D
class_name Door

@onready var anim: AnimationPlayer = %AnimationPlayer

var open : bool = false
var broken : bool = false

func interact() -> void:
	if open:
		anim.play("close")
	else:
		anim.play("open")
	open = not open

func breakdown(direction_z : Vector3) -> void:
	var point = global_position + direction_z
	var dot = direction_z.dot(global_basis.z)
	var offset = 0.75 * dot
	owner.look_at(point)
	position.x += offset
	anim.play("break")
	open = true
	broken = true
	$MeshInstance3D/NavigationObstacle3D.avoidance_enabled = false
	$CollisionShape3D.disabled = true
