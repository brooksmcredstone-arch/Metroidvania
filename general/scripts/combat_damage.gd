class_name CombatDamage extends RefCounted

static func calculate_damage(base_damage : float, atk : float, def : float) ->float:
	
	return maxf(1.0, base_damage + atk - def)
