@tool
extends Resource
class_name PredesignatedEffect

@export var effect_scene : PackedScene :
	set(variable):
		effect_scene = variable
		_properties()

var effect_vars : Array[Dictionary]
@export var eff_dict : Dictionary
var eff_vals : Array

func _properties() -> void:
	var eff_obj = effect_scene.instantiate()
	effect_vars = eff_obj.get_property_list()
	var real_properties : Array[Dictionary]
	var _node = Node.new()
	var blacklist = _node.get_property_list()
	_node.queue_free()
	for property in effect_vars:
		if not property in blacklist and property.usage != 128:
			real_properties.append(property)
			eff_vals.append(eff_obj.get(property.name))
	effect_vars = real_properties
	eff_obj.queue_free()
	_update_dict()

func _update_dict() -> void:
	var _i = 0
	for prop in effect_vars:
		var _name = prop.name
		var _val = eff_vals[_i]
		eff_dict[_name] = _val
		_i += 1
