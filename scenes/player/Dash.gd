extends PlayerState

# function to transition between states
func _get_next_state():
	pass

func _get_end_pos() -> Vector2:
	var mouse_pos := player.get_global_mouse_position()
	var relative_end_pos := Vector2(mouse_pos-player.global_position).limit_length(player.dash_distance*Globals.tile_size)
	return player.global_position + relative_end_pos

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
	player.global_position = _get_end_pos()
	animation_player.play("dash")
	await get_tree().create_timer(0.2).timeout
	player.unlock_state_switching()
	state_machine.transition_to("Idle")

# called when state is transitioned from
func exit():
	pass



func _on_dash_timer_timeout():
	state_machine.transition_to("Idle")
