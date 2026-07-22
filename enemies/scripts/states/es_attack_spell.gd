class_name ESAttackSpell extends ESAttack

@export var cast_duration : float = 1.0 
@export_file("*.tscn") var cast_scene : String



func enter() -> void:
	super()
	duration = cast_duration
	var spell : Node = load(cast_scene).instantiate()
	enemy.add_sibling(spell)
	if spell.has_method("set_enemy"):
		spell.set_enemy(enemy)
	pass
