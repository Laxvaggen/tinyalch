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
	animation_player.play("attack")
	await animation_player.animation_finished
	if !entity.player_in_attack_range():
		state_machine.transition_to("Hunt")
		return
	elif !entity.looking_towards_player():
		entity.set_node_direction(entity.direction * -1)
	if entity.get_sight_score_difference() < 0:
		state_machine.transition_to("Alert")
		entity.emit_signal("lost_player", entity)
		return
	enter()

# called when state is transitioned from
func exit():
	entity.disable_collision($"../../HitBox")

