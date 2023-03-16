class_name Entity
extends CharacterBody2D

#Base class for non-player and player characters

@export var max_health: int
@export var max_mana: int

## in tiles per second.
@export var move_speed_: int
## in tiles per second.
@export var sneak_speed_: int
## in tiles per second.
@export var air_speed_: int
## in tiles.
@export var jump_height_: int

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity := Globals.default_gravity
var max_fall_speed := Globals.max_fall_speed
var move_speed: float
var sneak_speed: float
var air_speed: float
var jump_strength: float

var direction := 1

@onready var health = max_health
@onready var mana = max_mana

@onready var state_machine:StateMachine
@onready var state_locked_timer: Timer
@onready var animation_player: AnimationPlayer

signal died
signal damage_taken(amount:int)

func _ready() -> void:
	_convert_stats()
	if has_node("StateMachine"):
		state_machine = $StateMachine
	else:
		push_error("EntityNoStateMachine")
	if has_node("StateMachineStateLockedTimer"):
		state_locked_timer = $StateLockedTimer
	if has_node("AnimationPlayer"):
		animation_player = $AnimationPlayer
	else:
		push_error("EntityNoAnimationPlayer")
	set_up_direction(Vector2.UP)
	if state_locked_timer != null:
		state_locked_timer.connect("timeout",Callable(self,"unlock_state_switching"))
	_enter()


func _process(delta: float) -> void:
	_update(delta)
	if state_machine != null:
		state_machine.state.update(delta)
	

func _physics_process(delta: float) -> void:
	_physics_update(delta)
	if state_machine != null:
		state_machine.state.physics_update(delta)
	
	move_and_slide()

func _enter() -> void:
	pass

func _update(_delta: float) -> void:
	pass

func _physics_update(_delta: float) -> void:
	pass

# converts movement stats from readable units to usable units
func _convert_stats() -> void:
	# to be multiplied by delta
	move_speed = move_speed_ * 16
	sneak_speed = sneak_speed_ * 16
	air_speed = air_speed_ * 16
	# max_jump_height = 3/2 * -jump_strength^2 / gravity
	# 
	jump_strength = sqrt(jump_height_*16*2*gravity)

func take_damage(damage: int, knockback: Vector2, _source: Node2D) -> void:
	health -= damage
	velocity = knockback
	emit_signal("damage_taken", damage)
	if state_machine == null:
		return
	if health <= 0 and state_machine.get_node("Dead"):
		state_machine.transition_to("Dead")
	elif state_machine.get_node("Hit"):
		state_machine.transition_to("Hit")

func gain_health(amount: int) -> void:
	health += amount
	if health > max_health:
		health = max_health

func gain_mana(amount: int) -> void:
	mana += amount
	if mana > max_health:
		mana = max_health

func disable_collision(target: Node2D) -> void:
	for child in target.get_children():
		if child is CollisionShape2D:
			child.set_deferred("disabled", true)
		disable_collision(child)

func apply_gravity(delta: float) -> void:
	velocity.y += gravity * delta

func lock_state_switching(time: float) -> void:
	if state_locked_timer == null:
		push_error("StateLockedTimerIsNull")
		return
	if state_machine == null:
		push_error("StateMachineIsNull")
		return
	if time <= 0:
		return
	state_locked_timer.stop()
	state_machine.state_locked = true
	state_locked_timer.start(time)

func unlock_state_switching() -> void:
	if state_machine == null:
		push_error("StateMachineIsNull")
		return
	if state_locked_timer == null:
		push_error("StateLockedTimerIsNull")
		return
	state_locked_timer.stop()
	state_machine.state_locked = false

func set_node_direction(new_direction: int, force_look_forward: bool = true) -> void:
	if !abs(direction) == 1:
		return
	if new_direction == direction:
		return

	flip_children(direction, self)
	
	direction = new_direction
	if force_look_forward:
		direction = new_direction

func flip_children(new_direction: int, target: Node2D) -> void:
	if target == null:
		return
	var sprite_face_left:= false
	if new_direction == -1:
		sprite_face_left = true
	for child in target.get_children():
		if child.get("no_flip"):
			pass
		else:
			if child.get("position"):
				child.position.x *= -1
			if child is Sprite2D:
				child.flip_h = sprite_face_left
			if child is RayCast2D:
				child.target_position.x *= -1
				
		flip_children(new_direction, child)
