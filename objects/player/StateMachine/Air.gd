extends PlayerState

var _power = 0.01

func on_physics_process(delta):
	handle_fall(delta)
	handle_landing()
	handle_movement(delta)


func handle_landing():
	if player.legs.is_touching_floor():
		if player.velocity.y <= -10:
			var _dmg = -player.velocity.y * 5
			player.health.receive_damage(_dmg, self)
		change_state("Walk")
