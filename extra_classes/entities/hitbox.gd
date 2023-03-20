class_name HitBox
extends Area2D

@export var damage := 10
@export var knockback := 50

@export var disabled_on_start: bool = false

func _init():
	collision_layer = 5
	collision_mask = 6

func _ready():
	if disabled_on_start:
		$CollisionShape2D.set_deferred("disabled", true)
