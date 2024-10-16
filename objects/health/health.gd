extends Node
class_name Health

@export var parent : Node

signal hp_changed(result_hp : float, difference : float)
signal damaged(amount_dealt : float, original_amount : float, source_of_damage : Node)
signal healed(amount_healed : float, original_amount : float, source_of_healing : Node)
signal final_blow(killer : Node)

var current_hp

func _ready():
	if not parent:
		parent = get_parent()
	current_hp = parent.stats.max_hp

func change_health(amount : float, source : Node) -> void:
	current_hp += amount
	current_hp = clamp(current_hp, 0, parent.stats.max_hp)
	hp_changed.emit(current_hp, amount)
	if current_hp <= 0.05:
		final_blow.emit(source)

func receive_damage(amount : float, source : Node) -> void:
	if amount <= 0:
		return
	
	var accumulative_damage : float = amount
	accumulative_damage += amount / 100 * parent.stats.damage_susceptibility
	
	var mitigated_damage : float = 0
	if parent.stats.damage_resistance >= 0:
		mitigated_damage = accumulative_damage * (100 / (100 + parent.stats.damage_resistance))
	else:
		mitigated_damage = accumulative_damage * (2 - (100 / (100 - parent.stats.damage_resistance)))
	change_health(-mitigated_damage, source)
	damaged.emit(mitigated_damage, accumulative_damage, source)

func receive_healing(amount : float, source : Node) -> void:
	if amount <= 0:
		return
		
	var accumulative_healing : float = amount
	accumulative_healing += amount / 100 * parent.stats.healing_susceptibility
	
	var mitigated_healing : float = 0
	if parent.stats.healing_resistance >= 0:
		mitigated_healing = accumulative_healing * (100 / (100 + parent.stats.healing_resistance))
	else:
		mitigated_healing = accumulative_healing * (2 - (100 / (100 - parent.stats.healing_resistance)))
	change_health(mitigated_healing, source)
	healed.emit(mitigated_healing, accumulative_healing, source)

	
	
	
