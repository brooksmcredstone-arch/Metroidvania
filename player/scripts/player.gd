class_name Player extends CharacterBody2D




#region On Ready Variables
@onready var sprite = $Sprite2D
@onready var collision_stand = $CollisionStand
@onready var collision_crouch = $CollisionCrouch
@onready var animation_player = $AnimationPlayer
@onready var one_way_platform_shape_cast = $OneWayPlatformShapeCast
@onready var attack_area: AttackArea = %AttackArea
 
#endregion

#region Export Variabes
@export var move_speed : float = 150
@export var max_fall_velocity : float = 600
#endregion

#region State Machines Variables
# references all state variables
var states : Array [PlayerState]
var current_state : PlayerState :
	get : return states.front()
var previous_state : PlayerState :
	get : return states[1]
#endregion

#region  Player Stats
var hp : float = 20:
	set(value):
		hp = clampf(value, 0, max_hp)
		Messages.player_health_changed.emit(hp, max_hp)
var max_hp : float = 20:
	set(value):
		max_hp = value
		Messages.player_health_changed.emit(hp, max_hp)
	
var mp : float = 20
var max_mp : float = 20
var lvl : float = 1
var experience: float = 0
var dash : bool = false
var double_jump : bool = false
var ground_pound : bool = false
var floatation : bool = false
#endregion

#region Standard Variables
# Where all standad varaibles go
var direction : Vector2 = Vector2.ZERO
var gravity : float = 980
var gravity_multiplier : float = 1.0
#endregion

func _ready() -> void:
	if get_tree().get_first_node_in_group("Player")!= self:
		self.queue_free()
	initialize_states()
	self.call_deferred("reparent", get_tree().root)
	Messages.player_healed.connect(_on_player_healed)
	Messages.back_to_title_screen.connect(queue_free)
	pass

func _unhandled_input(event : InputEvent) -> void:
	#enables actions
	if event.is_action_pressed("action"):
		Messages.player_interacted.emit(self)
		#pauses the game
	elif event.is_action_pressed("pause"):
		get_tree().paused = true
		var pause_menu : PauseMenu = load("res://metroidvania_project/pause_menu/pause_menu.tscn").instantiate()
		add_child(pause_menu)
		return
	change_state(current_state.handle_input(event))
	pass
	
	if OS.is_debug_build():
		if event.is_action_pressed("attack"):
			$AttackArea.activate()
			return
		if event is InputEventKey and event.pressed:
			if event.keycode == KEY_MINUS:
				if  Input.is_key_pressed(KEY_SHIFT):
					max_hp -= 10
				else:
					hp -= 2
			elif event.keycode == KEY_EQUAL:
				if Input.is_key_pressed(KEY_SHIFT):
					max_hp += 10
				else:
					hp += 2

func _process(_delta: float) -> void:
	update_direction()
	change_state(current_state.process(_delta))
	
	pass

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta * gravity_multiplier
	velocity.y = clampf(velocity.y, -1000.0, max_fall_velocity)
	move_and_slide()
	change_state(current_state.physics_process(delta))
	
	pass

func initialize_states() -> void:
	states = []
	#gather all states
	for c in $States.get_children():
		if c is PlayerState:
			states.append(c)
			c.player = self
		pass
	
	if states.size() == 0:
		return
	
	#initialize all states
	for state in states:
		state.init()
	
	change_state(current_state)
	current_state.enter()
	$Label.text = current_state.name
	pass

func change_state(new_state : PlayerState) -> void:
	if new_state == null:
		return
	elif new_state ==  current_state:
		return
	
	if current_state:
		current_state.exit()
	
	states.push_front(new_state)
	current_state.enter()
	states.resize(3)
	$Label.text = current_state.name
	pass

func update_direction() -> void:
	var prev_direction : Vector2 = direction
	
	var x_axis = Input.get_axis("left", "right")
	var y_axis = Input.get_axis("up", "down")
	
	direction = Vector2(x_axis, y_axis)
	#directional input stuff
	if prev_direction.x != direction.x:
		attack_area.flip(direction.x)
		if direction.x < 0:
			sprite.flip_h = true
		elif direction.x > 0:
			sprite.flip_h = false
	pass

func _on_player_healed(amount : float) -> void:
	hp += amount
	print("Player healed: ", amount)
	#audio-visual
	pass
