class_name HurtBox
extends Area2D

func _init():
	collision_layer = 5
	collision_mask = 6



func _ready():
	connect("area_entered",Callable(self,"_on_area_entered"))



func _on_area_entered(hitbox) -> void: # called when hitbox is detected
	if hitbox == null or !hitbox is HitBox:
		return
	elif hitbox.owner == owner:
		return
	var knockback_vector: Vector2 = (global_position - hitbox.global_position).normalized()
	if owner.has_method("take_damage"):
		owner.take_damage(hitbox.damage, knockback_vector*hitbox.knockback, hitbox.owner)
