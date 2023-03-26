extends PlayerState

# function to transition between states
func _get_next_state():
	if Input.is_action_pressed("dash"):
		state_machine.transition_to("Dash")
	if player.is_ceiling_low():
		return
	if !player.is_on_floor():
		state_machine.transition_to("Air")
	elif Input.is_action_just_pressed("sneak"):
		state_machine.transition_to("Idle", {noForceAnimation=true})
	elif Input.is_action_pressed("jump"):
		state_machine.transition_to("Air", {doJump=true})
	elif Input.is_action_pressed("fall_through"):
		if player.is_on_platform():
			player.position.y += 2
			state_machine.transition_to("Air")
	

# is called as a _process()
func update(_delta):
	_get_next_state()


# is called as a _physics_process()
func physics_update(_delta):
	var in_transition_animation := false
	if animation_player.current_animation == "transition_to_crouch":
		in_transition_animation = true
	if Input.is_action_pressed("move_left"):
		player.velocity = player.velocity.move_toward(Vector2(player.sneak_speed*-1, 0), player.ground_acceleration*_delta)
		if !in_transition_animation:
			animation_player.play("crouch_walk")
	elif Input.is_action_pressed("move_right"):
		player.velocity = player.velocity.move_toward(Vector2(player.sneak_speed*1, 0), player.ground_acceleration*_delta)
		if !in_transition_animation:
			animation_player.play("crouch_walk")
	else:
		player.velocity = player.velocity.move_toward(Vector2(0, 0), player.ground_acceleration*_delta)
		if !in_transition_animation:
			animation_player.play("crouch_idle")

# called when state is transitioned to
func enter(_msg = {}):
	player.lock_state_switching(0.1)
	animation_player.play("transition_to_crouch")
	player.set_collision_height("low")
	create_tween().tween_property($"../../PointLight2D", "energy", 0.1, 1)

# called when state is transitioned from
func exit():
	animation_player.play("transition_to_stand")
	player.set_collision_height("high")
	player.lock_state_switching(0.1)
	create_tween().tween_property($"../../PointLight2D", "energy", 0.5, 0.5)

