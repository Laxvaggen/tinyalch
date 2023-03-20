extends PlayerState

# function to transition between states
func _get_next_state():
	if !player.is_on_floor():
		state_machine.transition_to("Air")
	elif Input.is_action_pressed("sneak"):
		state_machine.transition_to("Sneak")
	elif Input.is_action_pressed("jump"):
		state_machine.transition_to("Air", {doJump=true})
	elif Input.is_action_pressed("fall_through"):
		if player.is_on_platform():
			player.position.y += 2
			state_machine.transition_to("Air")
	elif !Input.is_action_pressed("move_left") and !Input.is_action_pressed("move_right"):
		state_machine.transition_to("Idle", {noForceAnimation=true})
	elif Input.is_action_pressed("dash"):
		state_machine.transition_to("Dash")

# is called as a _process()
func update(_delta):
	_get_next_state()


# is called as a _physics_process()
func physics_update(_delta):
	if Input.is_action_pressed("move_left"):
		player.velocity = player.velocity.move_toward(Vector2(player.move_speed*-1, 0), player.ground_acceleration*_delta)
	elif Input.is_action_pressed("move_right"):
		player.velocity = player.velocity.move_toward(Vector2(player.move_speed*1, 0), player.ground_acceleration*_delta)
	

# called when state is transitioned to
func enter(_msg = {}):
	animation_player.play("run")

# called when state is transitioned from
func exit():
	animation_player.play("run_stop")

