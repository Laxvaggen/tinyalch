class_name EnemyHitState
extends EnemyState


# function to transition between states
func _get_next_state():
	pass

# is called as a _process()
func update(_delta):
	_get_next_state()


# is called as a _physics_process()
func physics_update(_delta):
	entity.apply_gravity(_delta)

# called when state is transitioned to
func enter(_msg = {}):
	entity.lock_state_switching(100)
	if animation_player.has_animation("hit"):
		animation_player.play("hit")
		await animation_player.animation_finished
		entity.unlock_state_switching()
		state_machine.transition_to("Hunt")
	else:
		await get_tree().create_timer(0.1).timeout
		entity.unlock_state_switching()
		state_machine.transition_to("Hunt")

# called when state is transitioned from
func exit():
	pass
