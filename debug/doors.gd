extends StaticBody3D

var open : bool = false

func interact() -> void:
	if open and not %AnimationPlayer.is_playing():
		open = false
		$Closed.disabled = false
		$Open.disabled = true
		$VisionShield/Vision.disabled = false
		%AnimationPlayer.play("close")
	else:
		open = true
		$Closed.disabled = true
		$Open.disabled = false
		$VisionShield/Vision.disabled = true
		%AnimationPlayer.play("open")
		
