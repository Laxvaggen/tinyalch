extends PlayerState

# function to transition between states
func _get_next_state():
	pass

# is called as a _process()
func update(_delta):
	_get_next_state()


# is called as a _physics_process()
func physics_update(_delta):
	pass

# called when state is transitioned to
func enter(_msg = {}):
	animation_player.play("die")
	player.velocity = Vector2.ZERO
	player.disable_collision(player)
	player.lock_state_switching(5)
	await animation_player.animation_finished
	player.emit_signal("died")

# called when state is transitioned from
func exit():
	pass

