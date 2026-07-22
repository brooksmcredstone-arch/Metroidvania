extends Node


func use_item(item : ItemData) -> bool:
	if item == null:
		return false
	
	var p := get_tree().get_first_node_in_group("Player") as Player
	if not p:
		push_warning("ItemEffectManager: No Player Found")
		return false
	
	match item.effect_type:
		ItemData.ItemEffectType.HEAL:
			return _apply_heal(p, item)
		ItemData.ItemEffectType.RESTORE_MP:
			return _apply_restore_mp(p, item)
		ItemData.ItemEffectType.CURE_STATUS:
			return _apply_cure_status(p, item)
		ItemData.ItemEffectType.NONE:
			push_warning("ItemEffectManager: Item is not assigned")
			return false
	return false

func _apply_heal(player : Player, item : ItemData) -> bool:
	if player.hp >= player.max_hp:
		return false
	Messages.player_healed.emit(item.effect_value)
	return true


func _apply_restore_mp(player : Player, item : ItemData) -> bool:
	if player.mp >= player.max_mp:
		return false
	player.mp = minf(player.mp + item.effect_value, player.max_mp)
	return true

func _apply_cure_status(player : Player, item : ItemData) -> bool:
	if player.hp >= player.max_hp:
		return false
	Messages.player_healed.emit(item.effect_value)
	return false
