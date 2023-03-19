extends PlayerState

# function to transition between states
func _get_next_state():
	if player.is_on_floor():
		state_machine.transition_to("Idle", {noForceAnimation=true})
	elif player.is_on_edge() and player.velocity.y >= 0:
		state_machine.transition_to("EdgeHang")
	elif Input.is_action_pressed("dash"):
		state_machine.transition_to("Dash")

# is called as a _process()
func update(_delta):
	_get_next_state()
	

# is called as a _physics_process()
func physics_update(_delta):
	player.apply_gravity(_delta)
	if Input.is_action_pressed("move_left"):
		player.velocity = player.velocity.move_toward(Vector2(player.air_speed*-1, player.velocity.y), player.air_acceleration*_delta)
	elif Input.is_action_pressed("move_right"):
		player.velocity = player.velocity.move_toward(Vector2(player.air_speed*1, player.velocity.y), player.air_acceleration*_delta)
	else:
		player.velocity = player.velocity.move_toward(Vector2(0, player.velocity.y), player.air_acceleration*_delta)
	
	if player.velocity.y > 0:
		animation_player.play("fall")
	else:
		animation_player.play("jump")

# called when state is transitioned to
func enter(_msg = {}):
	if _msg.has("doJump"):
		player.jump()

# called when state is transitioned from
func exit():
	animation_player.play("land")
