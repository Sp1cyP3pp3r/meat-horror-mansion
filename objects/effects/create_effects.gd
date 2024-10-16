extends Resource
class_name CreateEffects

@export var predesignated_effects : Array[PredesignatedEffect]
@export var custom_effects : Array[EffectedProperties]
@export var create_timer : bool = false
@export_range(0, 100, 0.025) var timer_wait_time : float = 0

var effects_array : Array[Effect] = []

func add_effects(affected_object, override_properties : Dictionary = {})\
 -> Array[Effect]:
	effects_array.clear()
	if predesignated_effects.is_empty() and custom_effects.is_empty():
		#print(str(self.name) + " does not contain effects")
		return []
	if not custom_effects.is_empty():
		var new_effect = create_custom_effect(override_properties)
		if create_timer:
			create_effect_timer(new_effect)
		affected_object.add_child(new_effect)
	
	if not predesignated_effects.is_empty():
		create_predesignated_effects(affected_object, override_properties)
	
	return effects_array.duplicate()

func create_custom_effect(override_properties) -> Effect:
	var new_effect = Effect.new()
	for effected_properties in custom_effects:
		var _dict : EffectedProperties = effected_properties.duplicate()
		if effected_properties.property_name in override_properties.keys():
			_dict.property_modificator = override_properties[effected_properties.property_name]
		new_effect.properties_array.append(_dict)
	effects_array.append(new_effect)
	return new_effect

func create_predesignated_effects(affected_object, override_properties) -> void:
	for predefined_effect in predesignated_effects:
		var scene = predefined_effect.effect_scene
		var created_effect = scene.instantiate()
		var dict = predefined_effect.eff_dict
		for property in dict.keys():
			var _prop : Variant = dict[property]
			if property in override_properties.keys():
				_prop = override_properties[property]
			if property in created_effect:
					created_effect.set(property, _prop)
		if create_timer:
			create_effect_timer(created_effect)
		effects_array.append(created_effect)
		affected_object.add_child(created_effect)

func create_effect_timer(effect) -> void:
	var new_timer = Timer.new()
	new_timer.wait_time = timer_wait_time
	new_timer.connect(&"timeout", Callable(effect, &"discard_effects"))
	new_timer.one_shot = true
	new_timer.autostart = true
	effect.add_child(new_timer)
