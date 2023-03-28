class_name EnemyHuntState
extends EnemyState


@export var run_animation_name: String  = "run"
# update player location constantly. if cannot see player anymore, go back to alert
# always move towards player location
# and transition to attack if within range

# function to transition between states
func _get_next_state():
	if entity.get_sight_score_difference() > 0:
		if !entity.looking_towards_player():
			entity.set_node_direction(entity.direction*-1)
		if entity.player_in_attack_range():
			state_machine.transition_to("Attack")
	else:
		entity.emit_signal("lost_player", entity)
		state_machine.transition_to("Alert", {play_icon=true})

# is called as a _process()
func update(_delta):
	_get_next_state()


# is called as a _physics_process()
func physics_update(_delta):
	entity.last_known_player_location = entity.player.global_position
	entity.pathfinder_set_target(entity.last_known_player_location)
	entity.apply_gravity(_delta)
	entity.pathfind(1)


# called when state is transitioned to
func enter(_msg = {}):
	animation_player.play(run_animation_name)
	if _msg.has("play_icon"):
		entity.display_information_icon(entity.hunt_icon.instantiate(), 0.25, 0.25, 0.5)
		entity.play_sound_effect(entity.hunt_noise)

# called when state is transitioned from
func exit():
	pass

