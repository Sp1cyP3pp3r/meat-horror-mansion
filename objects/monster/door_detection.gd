extends Area3D

var current_door
var temper : int = 0
@onready var timer : Timer = $TemperMeter


signal break_door

func _physics_process(delta: float) -> void:
	if current_door:
		if not current_door.open:
			if temper >= 3:
				break_door.emit(-global_basis.z)

func _on_body_entered(body: Node3D) -> void:
	if body is Door:
		current_door = body
		if not current_door.open:
			break_door.connect(current_door.breakdown)
			timer.start()


func _on_body_exited(body: Node3D) -> void:
	if body == current_door:
		temper = 0
		break_door.disconnect(current_door.breakdown)
		timer.stop()
		current_door = null


func _on_temper_meter_timeout() -> void:
	temper += 1
	timer.start()
