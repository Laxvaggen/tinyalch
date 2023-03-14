class_name EnemyState
extends State

var entity: Enemy

func _ready() -> void:
	await owner.ready
	entity = owner as Enemy
