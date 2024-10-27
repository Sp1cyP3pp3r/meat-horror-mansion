extends Node3D

@onready var viewport: SubViewport = %SubViewport
@onready var camera: Camera3D = %Camera3D

var light_level : float

func _ready() -> void:
	viewport.debug_draw = Viewport.DEBUG_DRAW_LIGHTING

func update_light() -> void:
	camera.global_position = global_position + Vector3.UP
	var texture = viewport.get_texture()
	$TextureRect.texture = texture
	var color = get_average_color(texture)
	$TextureRect/ColorRect.color = color
	light_level = 100 - color.get_luminance() * 100
	$TextureRect/Label.text = str(light_level)


func get_average_color(texture : ViewportTexture) -> Color:
	if texture:
		var image : Image = texture.get_image()
		image.resize(1, 1, Image.INTERPOLATE_BILINEAR)
		return image.get_pixel(0, 0)
	return Color.FUCHSIA
