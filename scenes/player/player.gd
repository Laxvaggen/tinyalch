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
var fire_blast = preload("res://scenes/player/fire_effect.tscn")
var water_splash = preload("res://scenes/player/water_effect.tscn")
var spells = ["fury_fists", "magma_shot", "rage", "heal"]
var selected_spell = spells[0]
var max_magma_shot_range = 5 * Globals.tile_size

var magic_state = "water"

var heal_sound = load("res://sound/Retro Magic 11.wav")
var jump_sound = load("res://sound/feet_13.wav")

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
	if Input.is_action_just_pressed("switch_magic_state"):
		switch_magic_state()
	if magic_state == "water":
		water_state()
	elif magic_state == "fire":
		fire_state()

func _set_bars() -> void:
	$StatusBars.get_node("HealthBar").value = 100*health/max_health
	if animation_player.current_animation == "crouch_idle" or animation_player.current_animation == "crouch_walk":
		$StatusBars.position.y = -10
	else:
		$StatusBars.position.y = -20


func water_state() -> void:
	if state_machine.state.name in ["Sneak", "Dash", "CastSpell"]:
		return
	if Input.is_action_pressed("cast_spell_1"):
		state_machine.transition_to("CastSpell", {spell_water_quick_slashes=true})
	elif Input.is_action_just_pressed("cast_spell_2"):
		state_machine.transition_to("CastSpell", {spell_water_spear=true})
	
func fire_state() -> void:
	if state_machine.state.name in ["Sneak", "Dash", "CastSpell"]:
		return
	if Input.is_action_pressed("cast_spell_1"):
		state_machine.transition_to("CastSpell", {spell_fire_fury_fists=true})
	elif Input.is_action_just_pressed("cast_spell_2"):
		state_machine.transition_to("CastSpell", {spell_fire_magma_shot=true})

func switch_magic_state() -> void:
	if state_machine.state_locked:
		return
	if state_machine.state.name in ["Sneak", "Dash", "CastSpell"]:
		return
	if magic_state == "water":
		magic_state = "fire"
		enter_fire_state()
	elif magic_state == "fire":
		magic_state = "water"
		enter_water_state()

func enter_fire_state() -> void:
	state_machine.transition_to("CastSpell", {rage=true})

func enter_water_state() -> void:
	state_machine.transition_to("CastSpell", {splash=true})
	var splash_instance = water_splash.instantiate()
	splash_instance.position = Vector2(0, 6)
	add_child(splash_instance)

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
	await get_tree().process_frame
	var pos = global_position + Vector2(get_global_mouse_position()-global_position).limit_length(max_magma_shot_range)
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(Vector2(pos.x, pos.y - 1), Vector2(pos.x, pos.y + 1000), 1)
	var result = space_state.intersect_ray(query)
	if result:
		var shot_instance = magma_shot.instantiate()
		shot_instance.global_position = result["position"]
		shot_instance.get_node("HitBox")
		get_node("/root/World").add_child(shot_instance)


func jump() -> void:
	velocity.y = -jump_strength
	global_position.y -= 1
	play_sound_effect(jump_sound)


func _on_heal_sprite_animation_finished():
	$HealSprite.visible = false


func _on_second_timer_timeout():
	if magic_state == "water":
		gain_health(3)
	elif magic_state == "fire":
		get_node("Sprite").modulate = Color(10,10,10,10)
		gain_health(-10)
		var blast_instance = fire_blast.instantiate()
		blast_instance.global_position = global_position + Vector2(0, 3)
		get_node("/root/World").add_child(blast_instance)
		await get_tree().create_timer(0.1).timeout
		get_node("Sprite").modulate = Color(1, 1, 1, 1)


func _on_hit_box_area_entered(area):
	if area.owner == self:
		return
	if animation_player.current_animation == "spell_water_quick_slashes":
		gain_health(10)
		play_sound_effect(heal_sound, -15)
		$HealSprite.play("default")
		$HealSprite.visible = true
		



func _on_wave_slam_hit_box_area_entered(area):
	if area.owner == self:
		return
	gain_health(25)
	play_sound_effect(heal_sound, -15)
	$HealSprite.play("default")
	$HealSprite.visible = true
