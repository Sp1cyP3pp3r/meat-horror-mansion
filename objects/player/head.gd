extends Node3D

var mouse_sensitivity = 0.11

@onready var head_free_space_cast = $HeadFreeSpaceCast
@onready var camera : Camera3D = $Camera
@onready var cursor_point: Marker3D = %CursorPoint
@export var fov : float= 75

var do_rotate_owner : bool = true
var free_cam : bool = false

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	camera.fov = fov
	initial_sens = mouse_sensitivity
	head_free_space_cast.add_exception(owner)

func _unhandled_input(event):
	if is_multiplayer_authority():
		if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			if do_rotate_owner:
				owner.rotation_degrees.y -= event.relative.x * mouse_sensitivity
			else:
				camera.rotation_degrees.y -= event.relative.x * mouse_sensitivity
			camera.rotation_degrees.x -= event.relative.y * mouse_sensitivity

var zoomed : bool = false
var initial_sens
func _physics_process(delta):
	camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-87), deg_to_rad(87))

func head_free_space() -> bool:
	head_free_space_cast.force_shapecast_update()
	if not head_free_space_cast.is_colliding():
		return true
	return false
