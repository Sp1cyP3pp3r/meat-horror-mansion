extends Node3D

@onready var viewcones : Array[Viewcone] = [
	$Viewcone,
	$ViewconeRight,
	$ViewconeLeft,
	$ViewconeBack
]


func sees_player() -> bool:
	for view in viewcones:
		if view.sees_player:
			return true
	return false


func see_interrupt(body: Node3D) -> void:
	owner.interrupt = true
