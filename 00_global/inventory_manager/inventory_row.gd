class_name InventoryRow extends Button

@onready var icon_rect: TextureRect = %Icon
@onready var item_name: Label = %ItemName
@onready var equip_marker: Label = %EquipMarker
@onready var quantity: Label = %Quantity

var associated_item : ItemData

func setup_row(item : ItemData, is_equipped : bool) -> void:
	associated_item = item
	item_name.text = item.name
	icon_rect.texture = item.texture
	
	equip_marker.visible = is_equipped
	
	if item.category == ItemData.ItemCategory.CONSUMABLE:
		quantity.text = "x" + str(item.quantity)
		quantity.show()
	else:
		quantity.hide()
	pass
