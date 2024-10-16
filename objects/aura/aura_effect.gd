extends Area3D
class_name Aura

@export var create_effects : CreateEffects

var entities_in_area : Array = []

func add_entity(object):
	var entity = object
	var entity_array : Array = [entity, create_effects.add_effects(entity)]
	entity.connect(&"tree_exiting", Callable(self, &"remove_entity"))
	entities_in_area.append(entity_array)


func remove_entity(object):
	var entity = object
	var array_to_delete : Array
	for nested_array in entities_in_area:
		if nested_array[0] == entity:
			for effect in nested_array[1]:
				if effect != null:
					effect.queue_free()
			# It is best to not erase something in array while iterating over it (real)
			array_to_delete = nested_array
	entity.disconnect(&"tree_exiting", Callable(self, &"remove_entity"))
	entities_in_area.erase(array_to_delete)

func _exit_tree() -> void:
	for nested_array in entities_in_area:
		for effect in nested_array[1]:
				if effect != null:
					effect.queue_free()
	
	
	
	
	
	
	
	
	
