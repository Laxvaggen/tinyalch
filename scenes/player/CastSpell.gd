extends PlayerState

var direction = 1

# function to transition between states
func _get_next_state():
	pass

# is called as a _process()
func update(_delta):
	_get_next_state()
	player.set_node_direction(direction)


# is called as a _physics_process()
func physics_update(_delta):
	player.apply_gravity(_delta)

# called when state is transitioned to
func enter(_msg = {}):
	player.velocity.x = 0
	direction = player.direction
	if _msg.has("rage"):
		animation_player.play("spell_fire_rage")
		player.lock_state_switching(0.5)
		await get_tree().create_timer(0.6).timeout
		state_machine.transition_to("Idle")
	elif _msg.has("splash"):
		animation_player.play("spell_water_enter")
		player.lock_state_switching(0.5)
		await get_tree().create_timer(0.7).timeout
		state_machine.transition_to("Idle")
	else:
		player.lock_state_switching(10)
		animation_player.play(_msg.keys()[0])
		await animation_player.animation_finished
		player.unlock_state_switching()
		state_machine.transition_to("Idle")

# called when state is transitioned from
func exit():
	pass

