class_name Player
extends Entity

func _enter():
	$HealSprite.visible = false

func _update(delta) -> void:
	pass

func enable_base_sprite() -> void:
	$Sprite.visible = true
	$FireAttackSprite.visible = false
	$WaterAttackSprite.visible = false

func enable_water_sprite() -> void:
	$Sprite.visible = false
	$FireAttackSprite.visible = false
	$WaterAttackSprite.visible = true

func enable_fire_sprite() -> void:
	$Sprite.visible = false
	$FireAttackSprite.visible = true
	$WaterAttackSprite.visible = false

func dash() -> void:
	global_position += Vector2(61*facing_x, 0)

func climb_ledge() -> void:
	global_position += Vector2(-10*facing_x, 16)

func _on_heal_sprite_animation_finished():
	$HealSprite.visible = false
