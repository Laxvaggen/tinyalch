class_name EnemyState
extends State

#Base class for states of non-player state machine

var entity: Enemy

func _ready() -> void:
	await owner.ready
	entity = owner as Enemy
