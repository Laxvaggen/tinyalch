extends PlayerState

# function to transition between states
func _get_next_state():
	if !player.is_on_floor():
		state_machine.transition_to("Air")
	elif Input.is_action_just_pressed("sneak"):
		state_machine.transition_to("Sneak")
	elif Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		state_machine.transition_to("Run")
	elif Input.is_action_pressed("jump"):
		state_machine.transition_to("Air", {doJump=true})
	elif Input.is_action_pressed("fall_through"):
		if player.is_on_platform():
			player.position.y += 2
			state_machine.transition_to("Air")
	elif Input.is_action_pressed("dash"):
		state_machine.transition_to("Dash")
	
# is called as a _process()
func update(_delta):
	_get_next_state()


# is called as a _physics_process()
func physics_update(_delta):
	player.velocity = player.velocity.move_toward(Vector2.ZERO, player.ground_acceleration * _delta)

# called when state is transitioned to
func enter(_msg = {}):
	if !_msg.has("noForceAnimation"):
		animation_player.play("idle")
	else:
		animation_player.queue("idle")

# called when state is transitioned from
func exit():
	pass
