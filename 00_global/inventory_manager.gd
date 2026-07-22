extends Node

signal inventory_updated

var player_inventory : Array[ItemData] = []

var equipped_weapon : ItemData = null
var equipped_armor : ItemData = null
var equipped_access : ItemData = null

func equip_item(item : ItemData, slot : String) -> void:
	match slot:
		"weapon":
			equipped_weapon = item
		"armor":
			equipped_armor = item
		"accessory":
			equipped_access = item
	inventory_updated.emit()
	pass

func is_item_equipped(item : ItemData) -> bool:
	
	return item == equipped_weapon or item == equipped_armor or item == equipped_access



func add_item(new_item : ItemData) -> void:
	if new_item.category == ItemData.ItemCategory.CONSUMABLE:
		for item in player_inventory:
			if item.name == new_item.name:
				item.quantity += 1
				inventory_updated.emit()
				return
	player_inventory.append(new_item.duplicate())
	inventory_updated.emit()
	pass 

func remove_item(old_item : ItemData) -> void:
	if old_item.category == ItemData.ItemCategory.CONSUMABLE and old_item.quantity > 1:
		old_item.quantity -= 1
	else:
		player_inventory.erase(old_item)
		inventory_updated.emit()
	pass

func get_item_category(target_category : ItemData.ItemCategory) -> Array[ItemData]:
	var cat_list : Array[ItemData] = []
	for item in player_inventory:
		if item.category == target_category:
			cat_list.append(item)
	return cat_list
