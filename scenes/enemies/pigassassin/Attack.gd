extends EnemyState


var last_attack := 3

# function to transition between states
func _get_next_state():
	pass

func _play_attack() -> void:
	if last_attack == 1:
		animation_player.play("attack_2")
		last_attack = 2
	elif last_attack == 2:
		animation_player.play("attack_3")
		last_attack = 3
	else:
		animation_player.play("attack_1")
		last_attack = 1

# is called as a _process()
func update(_delta):
	_get_next_state()


# is called as a _physics_process()
func physics_update(_delta):
	pass

# called when state is transitioned to
func enter(_msg = {}):
	entity.velocity = Vector2.ZERO
	last_attack = 0
	_play_attack()

# called when state is transitioned from
func exit():
	pass



func _on_animation_player_animation_finished(anim_name):
	if !"attack" in anim_name or state_machine.state != self:
		return
	if entity.player_in_attack_range():
		if !entity.looking_towards_player():
			entity.set_node_direction(entity.direction * -1)
		if entity.get_sight_score_difference() < 0:
			state_machine.transition_to("Alert")
			return
		_play_attack()
	else:
		state_machine.transition_to("Hunt")
