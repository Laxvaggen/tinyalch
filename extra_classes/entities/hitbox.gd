class_name HitBox
extends Area2D

@export var damage := 10
@export var knockback := 50

func _init():
	collision_layer = 5
	collision_mask = 6
