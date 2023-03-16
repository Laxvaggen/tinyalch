class_name Player
extends Entity

@export var base_visibility_score: int
@export var base_noise_score: int

@export var light_visibility_score: int

var visibility_score: float
var noise_score: float

func _enter():
	$HealSprite.visible = false

func _update(delta) -> void:
	visibility_score = get_visibility_score()

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

func is_ceiling_low() -> bool:
	var raycast = $HeadInterferenceRaycast
	raycast.enabled = true
	raycast.force_raycast_update()
	if raycast.is_colliding() and raycast.get_collider().is_in_group("Level"):
		raycast.enabled = false
		return true
	raycast.enabled = false
	return false

func is_on_edge() -> bool:
	if !is_on_wall():
		return false
	if !$EdgeFinderTop.is_colliding() and $EdgeFinderBottom.is_colliding():
		return true
	else:
		return false
	

func set_collision_height(height: String) -> void:
	assert(height == "low" or height == "high")
	if height == "low":
		$CollisionShapeLow.set_deferred("disabled", false)
		$CollisionShapeHigh.set_deferred("disabled", true)
	else:
		$CollisionShapeLow.set_deferred("disabled", true)
		$CollisionShapeHigh.set_deferred("disabled", false)

func dash() -> void:
	global_position += Vector2(61*direction, 0)

func climb_ledge() -> void:
	global_position += Vector2(-10*direction, 16)

func get_brightness_visibility_multiplier() -> float:
	return 1

func get_visibility_score() -> float:
	return base_visibility_score * get_brightness_visibility_multiplier() * state_machine.state.state_visibility_multiplier

func get_noise_score() -> float:
	return base_visibility_score * state_machine.state.state_noise_multiplier

func _on_heal_sprite_animation_finished():
	$HealSprite.visible = false
