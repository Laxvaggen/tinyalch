class_name Player
extends Entity

@export var base_visibility_score: int
@export var base_noise_score: int

@export var light_visibility_modifier: int

## tiles
@export var dash_distance: int

var visibility_score: float
var noise_score: float
var is_in_light: bool

var magma_shot = preload("res://scenes/player/magma_shot.tscn")
var spells = ["fury_fists", "magma_shot", "rage", "heal"]
var selected_spell = spells[0]

func _enter():
	$HealSprite.visible = false
	$CollisionShapeLow.set_deferred("disabled", true)

func _update(_delta) -> void:
	visibility_score = get_visibility_score()
	noise_score = get_noise_score()
	if velocity.x > 0:
		set_node_direction(1)
	elif velocity.x < 0:
		set_node_direction(-1)
	select_spell()

func select_spell() -> void:
	if Input.is_action_just_pressed("select_spell_1"):
		selected_spell = spells[0]
	elif Input.is_action_just_pressed("select_spell_2"):
		selected_spell = spells[1]
	elif Input.is_action_just_pressed("select_spell_3"):
		selected_spell = spells[2]
	elif Input.is_action_just_pressed("select_spell_4"):
		selected_spell = spells[3]

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
	if raycast.is_colliding() and raycast.get_collider():
		return true
	return false

func is_on_edge() -> bool:
	if !is_on_wall():
		return false
	if !$EdgeFinderTop.is_colliding() and $EdgeFinderBottom.is_colliding():
		return true
	else:
		return false

func is_on_platform() -> bool:
	if !is_on_floor():
		return false
	var raycast: RayCast2D = $GroundFinder
	if !raycast.is_colliding():
		return false
	var tilemap: TileMap = raycast.get_collider()
	var cell_position: Vector2 = tilemap.local_to_map(tilemap.to_local(raycast.get_collision_point()))
	if tilemap.get_cell_tile_data(0, cell_position).get_custom_data("platform"):
		return true
	return false

func set_collision_height(height: String) -> void:
	assert(height == "low" or height == "high")
	if height == "low":
		$CollisionShapeLow.set_deferred("disabled", false)
		$CollisionShapeHigh.set_deferred("disabled", true)
	else:
		$CollisionShapeLow.set_deferred("disabled", true)
		$CollisionShapeHigh.set_deferred("disabled", false)

func climb_ledge() -> void:
	await get_tree().physics_frame
	global_position += Vector2(7*direction, -14)
	state_machine.transition_to("Idle")

func get_brightness_visibility_multiplier() -> float:
	if is_in_light:
		return light_visibility_modifier
	else:
		return 1

func get_visibility_score() -> float:
	return base_visibility_score * get_brightness_visibility_multiplier() * state_machine.state.state_visibility_multiplier

func get_noise_score() -> float:
	return base_noise_score * state_machine.state.state_noise_multiplier

func receive_light_level(lightcone_colliding:bool) -> void:
	is_in_light = lightcone_colliding

func summon_magma_shot() -> void:
	var shot_instance = magma_shot.instantiate()
	shot_instance.global_position = get_global_mouse_position()
	get_node("/root/World").add_child(shot_instance)


func _on_heal_sprite_animation_finished():
	$HealSprite.visible = false
