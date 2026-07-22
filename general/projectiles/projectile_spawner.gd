class_name Projectile_Spawner extends Marker2D

@export var projectile : PackedScene

var og_position : Vector2


func _ready() -> void:
	og_position = position
	if owner is Enemy:
		owner.direction_changed.connect(_on_direction_changed)
	pass 


func fire_projectile(target_position : Vector2, delay : float = 0.0) -> void:
	await get_tree().create_timer(delay).timeout
	
	if not projectile:
		return
	
	var p = projectile.instantiate()
	get_tree().root.add_child(p)
	p.global_position = global_position
	
	if p is Projectile:
		p.start(target_position)
	pass

func fire_at_player(delay : float) -> void:
	var p : Player = null
	p = get_tree().get_first_node_in_group("Player")
	if p:
		fire_projectile(p.global_position + Vector2(0.0,-10.0), delay)
	pass


func _on_direction_changed(new_dir : float) -> void:
	if new_dir < 0:
		position.x  = -og_position.x
	elif new_dir > 0:
		position.x  = og_position.x
	pass
