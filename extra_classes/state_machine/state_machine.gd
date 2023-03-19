class_name StateMachine
extends Node

signal transitioned(state_name)

var state_locked := false

@export var initial_state := NodePath()

@onready var state: State = get_node(initial_state)


func _ready() -> void:
	await owner.ready
	for child in get_children():
		child.state_machine = self
	state.enter()

func set_references(owner_entity: Entity, animation_player: AnimationPlayer) -> void:
	for child in get_children():
		child.state_machine = self
		child.animation_player = animation_player
		child.entity = owner_entity

func _unhandled_input(event: InputEvent) -> void:
	state.handle_input(event)

func _process(delta: float) -> void:
	state.update(delta)

func _physics_process(delta: float) -> void:
	state.physics_update(delta)

#Exit current state and enter new state
func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
	if not has_node(target_state_name) or state_locked:
		return
	
	state.exit()
	state = get_node(target_state_name)
	state.enter(msg)
	emit_signal("transitioned", state.name)
