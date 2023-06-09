class_name EnemyHitState
extends EnemyState



@export var hit_sound:AudioStream

# function to transition between states
func _get_next_state():
	if entity.get_sight_score_difference() < 0:
		state_machine.transition_to("Alert")
	else:
		state_machine.transition_to("Hunt")

# is called as a _process()
func update(_delta):
	pass


# is called as a _physics_process()
func physics_update(_delta):
	entity.apply_gravity(_delta)

# called when state is transitioned to
func enter(_msg = {}):
	entity.play_sound_effect(hit_sound)
	entity.lock_state_switching(100)
	if animation_player.has_animation("hit"):
		animation_player.play("hit")
		await animation_player.animation_finished
		entity.unlock_state_switching()
		_get_next_state()
	else:
		await get_tree().create_timer(0.1).timeout
		entity.unlock_state_switching()
		_get_next_state()

# called when state is transitioned from
func exit():
	pass
