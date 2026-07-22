#What happens when the game is paused
class_name PauseMenu extends CanvasLayer

#region //Interactive Elements for Pause Menu
@onready var pause_screen : Control = %PauseScreen
@onready var system_screen : Control = %SystemScreen
@onready var inventory_screen: Control = %InventoryScreen

@onready var system : Button = %System
@onready var inventory: Button = %Inventory

@onready var map : Button = %Map
@onready var title : Button = %Title
@onready var music_slider : HSlider = %MusicSlider
@onready var sfx_slider : HSlider = %SFXSlider
@onready var ui_slider : HSlider = %UISlider

@onready var category_tab: TabBar = %CategoryTab
@onready var scroll_list: ScrollContainer = %ScrollList
@onready var list: VBoxContainer = %List
@onready var description_text: RichTextLabel = %DescriptionText
@onready var weapon: Label = %Weapon
@onready var armor: Label = %Armor
@onready var accessory: Label = %Accessory

const INVENTORY_ROW_SCENE = preload("res://metroidvania_project/00_global/inventory_manager/inventory_row.tscn")
var current_category : ItemData.ItemCategory = ItemData.ItemCategory.CONSUMABLE
#endregion

var player_pos : Vector2

func _ready()-> void:
	#grab player
	_show_pausescreen()
	system.pressed.connect(_show_system_menu)
	inventory.pressed.connect(_show_inventory_menu)
	
	category_tab.tab_changed.connect(_on_tab_changed)
	InventoryManager.inventory_updated.connect(refresh_inventory_ui)
	Audio.setup_button_audio(self)
	setup_system_menu()
	
	var player : Node2D = get_tree().get_first_node_in_group("Player")
	if player:
		player_pos = player.global_position
	
	inventory.focus_neighbor_bottom = system.get_path()
	system.focus_neighbor_top = inventory.get_path()
	pass


func _unhandled_input(event : InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_viewport().set_input_as_handled()
		get_tree().paused = false
		
		if inventory_screen and inventory_screen.has_method("close_inventory"):
			inventory_screen.close_inventory()
		queue_free()
	
	if inventory_screen.visible == true:
		if event.is_action_pressed("ui_focus_next"):
			category_tab.current_tab = (category_tab.current_tab + 1) % category_tab.tab_count
		elif event.is_action_pressed("ui_focus_prev"):
			category_tab.current_tab = (category_tab.current_tab - 1 + category_tab.tab_count) % category_tab.tab_count
	
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		_show_pausescreen()
		inventory.grab_click_focus()
	
	if pause_screen.visible == true:
		if event.is_action_pressed("down") or event.is_action_pressed("right"):
			if not system.has_focus() and not inventory.has_focus():
				inventory.grab_focus()
	pass



func _show_pausescreen() -> void:
	pause_screen.visible = true
	system_screen.visible = false
	inventory_screen.visible = false
	pass


func _show_system_menu() -> void:
	pause_screen.visible = false
	system_screen.visible = true
	inventory_screen.visible = false
	map.grab_focus()
	pass

func _show_inventory_menu() -> void:
	pause_screen.visible = false
	system_screen.visible = false
	inventory_screen.visible = true
	
	refresh_inventory_ui()
	
	if list.get_child_count() >0:
		list.get_child(0).grab_focus()
	pass

func setup_system_menu() -> void:
	music_slider.value = AudioServer.get_bus_volume_linear(2)
	sfx_slider.value = AudioServer.get_bus_volume_linear(3)
	ui_slider.value = AudioServer.get_bus_volume_linear(4)
	
	music_slider.value_changed.connect(_on_music_slider_changed)
	sfx_slider.value_changed.connect(_on_sfx_slider_changed)
	ui_slider.value_changed.connect(_on_ui_slider_changed)
	
	title.pressed.connect(_on_title_button_pressed)
	map.pressed.connect(_show_pausescreen)
	pass 


func _on_title_button_pressed() -> void:
	#free player
	SceneManager.transition_to_scene("res://metroidvania_project/title_screen/title_screen.tscn", "", Vector2.ZERO, "Up")
	get_tree().paused = false
	Messages.back_to_title_screen.emit()
	queue_free()
	pass


func _on_music_slider_changed(v : float) -> void:
	AudioServer.set_bus_volume_linear(2, v)
	SaveManager.save_configuration()
	
	pass


func _on_sfx_slider_changed(v : float) -> void:
	AudioServer.set_bus_volume_linear(3, v)
	Audio.play_spatial_sound(Audio.ui_focus_audio, player_pos)
	SaveManager.save_configuration()
	
	pass


func _on_ui_slider_changed(v : float) -> void:
	AudioServer.set_bus_volume_linear(3, v)
	SaveManager.save_configuration()
	pass


func _on_tab_changed(tab_index : int) -> void:
	current_category = tab_index as ItemData.ItemCategory
	refresh_inventory_ui()
	if list.get_child_count() > 0:
		list.get_child(0).grab_focus()
	pass

func refresh_inventory_ui() ->void:
	weapon.text = "Weapon: " + (InventoryManager.equipped_weapon.name if InventoryManager.equipped_weapon else "None")
	armor.text = "Armor: " + (InventoryManager.equipped_armor.name if InventoryManager.equipped_armor else "None")
	accessory.text = "Access-: " + (InventoryManager.equipped_access.name if InventoryManager.equipped_access else "None")
	
	for child in list.get_children():
		child.queue_free()
	
	var items_to_show = InventoryManager.get_item_category(current_category)
	if items_to_show.is_empty():
		description_text.text = "[color=grey]No items in this category.[/color]"
		return
	
	for item in items_to_show:
		var row_instance = INVENTORY_ROW_SCENE.instantiate() as InventoryRow
		list.add_child(row_instance)
		
		var is_equipped = InventoryManager.is_item_equipped(item)
		row_instance.setup_row(item, is_equipped)
		
		row_instance.alignment = HORIZONTAL_ALIGNMENT_LEFT
		row_instance.expand_icon = true
		
		row_instance.focus_entered.connect(func():
			description_text.text = "[font_size=14]" + item.description + "[/font_size]"
			scroll_list.ensure_control_visible(row_instance)
			)
		row_instance.pressed.connect(func(): _on_item_row_pressed(item))
	pass

func _on_item_row_pressed(item : ItemData) -> void:
	if item.category== ItemData.ItemCategory.CONSUMABLE:
		InventoryManager.remove_item(item)
		#Calls Item Function
	elif item.category == ItemData.ItemCategory.WEAPON:
		InventoryManager.equip_item(item, "weapon")
	elif item.category == ItemData.ItemCategory.ARMOR:
		InventoryManager.equip_item(item, "armor")
	elif item.category == ItemData.ItemCategory.ACCESSORY:
		InventoryManager.equip_item(item, "accessory")
	pass
