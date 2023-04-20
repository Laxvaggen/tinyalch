class_name State
extends Node

var state_machine:StateMachine
var animation_player: AnimationPlayer
var entity: Entity

@export var damage_multiplier: float = 1

func handle_input(_event: InputEvent) -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func enter(_msg := {}) -> void:
	pass

func exit() -> void:
	pass
