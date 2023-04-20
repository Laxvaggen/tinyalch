class_name EnemyState
extends State

#Base class for states of non-player state machine

@export var state_vision_multiplier: float = 1
@export var state_hearing_multiplier: float = 1


func _ready() -> void:
	await owner.ready
	entity = owner as Enemy
