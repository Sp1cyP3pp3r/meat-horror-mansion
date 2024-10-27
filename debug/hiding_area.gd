extends Area3D
class_name HidingArea

var is_player_inside : bool = false

func _on_body_entered(body: Node3D) -> void:
	is_player_inside = true


func _on_body_exited(body: Node3D) -> void:
	is_player_inside = false
