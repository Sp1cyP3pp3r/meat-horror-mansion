extends Aura
class_name DamageZone

@export var parent = get_owner()
@onready var timer = $DealDamageTimer

var current_entity = null

func _ready():
	if parent.create_effects:
		create_effects = parent.create_effects

func damage_entity(entity : CharacterBody2D):
	if entity:
		current_entity = entity
	if parent.stats:
		if parent.stats.damage:
			var amount = parent.stats.damage
			var _reload_time = 1 / parent.stats.firerate if parent.stats.firerate != 0 else 10
			if current_entity.health_node is Health:
				var hn = current_entity.health_node as Health
				if create_effects:
					create_effects.add_effects(current_entity)
				hn.receive_damage(parent.stats.damage, parent)
				timer.start(_reload_time)

func discard_entity(entity : CharacterBody2D):
	if entity == current_entity:
		current_entity = null
	timer.stop()



func _on_deal_damage_timer_timeout():
	damage_entity(current_entity)
