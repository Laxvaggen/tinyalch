extends EnemyState

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
	entity.velocity = Vector2.ZERO
	animation_player.play("leap_attack")
	await  animation_player.animation_finished
	state_machine.transition_to("Hunt")

# called when state is transitioned from
func exit():
	entity.disable_collision($"../../HitBox")

