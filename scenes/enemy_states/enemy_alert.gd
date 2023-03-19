class_name EnemyAlertState
extends EnemyState

@export var sight_alert_threshold: float = -0.25

@export var run_animation_name: String  = "run"
@export var idle_animation_name: String = "idle"


# pathfind to last known player location, when reaches it, stand around for a little bit, then
# pathfind back to spawn location
# when in spawn location, transition to idle

# function to transition between states
func _get_next_state():
	pass

# is called as a _process()
func update(_delta):
	_get_next_state()


# is called as a _physics_process()
func physics_update(_delta):
	if entity.velocity.x == 0:
		animation_player.play(idle_animation_name)
	else:
		animation_player.play(run_animation_name, -1, 0.5)
	
	if entity.get_sight_score_difference() > 0:
		state_machine.transition_to("Hunt")
		entity.emit_signal("spotted_player")
		return
	elif entity.get_noise_score_difference() > 0 and !entity.looking_towards_player():
		entity.set_node_direction(entity.direction*-1)
	if entity.current_path == []:
		if entity.get_sight_score_difference() > sight_alert_threshold:
			entity.last_known_player_location = entity.player.global_position
			entity.pathfinder_set_target(entity.last_known_player_location)
		else:
			state_machine.transition_to("Idle")
			return
	else:
		entity.pathfind(0.5)
	
	if entity.get_noise_score_difference() > 0:
		entity.last_known_player_location = entity.player.global_position
		entity.pathfinder_set_target(entity.last_known_player_location)
	entity.apply_gravity(_delta)


# called when state is transitioned to
func enter(_msg = {}):
	entity.last_known_player_location = entity.player.global_position
	entity.pathfinder_set_target(entity.last_known_player_location)
	entity.display_information_icon(entity.alert_icon.instantiate(), 0.25, 0.25, 0.5)

# called when state is transitioned from
func exit():
	pass

