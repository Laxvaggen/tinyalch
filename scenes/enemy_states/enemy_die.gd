class_name EnemyDieState
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
	entity.lock_state_switching(100)
	entity.emit_signal("died")
	if animation_player.has_animation("die"):
		animation_player.play("die")
		await animation_player.animation_finished
		queue_free()
	else:
		queue_free()

# called when state is transitioned from
func exit():
	pass
