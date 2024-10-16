@tool
extends Resource
class_name EffectedProperties

enum MOD_MODE {Addition,Percentage}
@export var property_modificator : float
@export var modificator_mode : MOD_MODE

var saved_value : float = 0

var property_name : String = "Debug"
var dict : Dictionary

func _init() -> void:
	assign_object()

func assign_object():
	var gimmick = Player.new()
	dict = gimmick.stats.duplicate()
	notify_property_list_changed()
	gimmick.queue_free()

func _get_property_list() -> Array:
	return [
		{
			name = "property_name",
			type = TYPE_STRING,
			hint = PROPERTY_HINT_ENUM,
			hint_string = ",".join(PackedStringArray(dict.keys())),
			usage = PROPERTY_USAGE_DEFAULT,
		}
	]
