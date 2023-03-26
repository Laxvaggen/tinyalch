extends PlayerState


var dash_sound_effect = load("res://sound/Retro Charge 07.wav")
# function to transition between states
func _get_next_state():
	pass

func _get_end_pos() -> Vector2:
	if !_is_roofed():
		return player.global_position
	var pos = player.global_position + Vector2(player.get_global_mouse_position()-player.global_position).limit_length(player.dash_distance*Globals.tile_size)
	var space_state = player.get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(Vector2(pos.x, pos.y - 10), Vector2(pos.x, pos.y + 4*Globals.tile_size), 1)
	var result = space_state.intersect_ray(query)
	if result:
		return Vector2(result["position"] - Vector2(0, 6))
	else:
		return player.global_position

func _is_roofed() -> bool:
	var pos = player.global_position + Vector2(player.get_global_mouse_position()-player.global_position).limit_length(player.dash_distance*Globals.tile_size)
	var space_state = player.get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(Vector2(pos.x, pos.y - 10), Vector2(pos.x, pos.y - 1000), 1)
	var result = space_state.intersect_ray(query)
	if result:
		return true
	else:
		return false

# is called as a _process()
func update(_delta):
	_get_next_state()


# is called as a _physics_process()
func physics_update(_delta):
	pass

# called when state is transitioned to
func enter(_msg = {}):
	
	if $DashCooldown.time_left > 0:
		state_machine.transition_to("Idle")
		return
	player.lock_state_switching(100)
	$DashCooldown.start()
	player.velocity = Vector2.ZERO
	animation_player.play("dash", -1, -1, true)
	await animation_player.animation_finished
	await get_tree().process_frame
	player.global_position = _get_end_pos()
	player.play_sound_effect(dash_sound_effect)
	animation_player.play("dash")
	await get_tree().create_timer(0.2).timeout
	player.unlock_state_switching()
	if player.is_ceiling_low():
		state_machine.transition_to("Sneak")
	else:
		state_machine.transition_to("Idle")

# called when state is transitioned from
func exit():
	pass



func _on_dash_timer_timeout():
	state_machine.transition_to("Idle")
