extends PlayerState

var hit_sound = load("res://sound/hit_058.wav")
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
	player.play_sound_effect(hit_sound)
	$Hitstun.start()
	player.lock_state_switching(5)
	player.get_node("Sprite").modulate = Color(10,10,10,10)
	

# called when state is transitioned from
func exit():
	player.get_node("Sprite").modulate = Color(1,1,1,1)



func _on_hitstun_timeout():
	player.unlock_state_switching()
	if player.is_ceiling_low():
		state_machine.transition_to("Sneak")
	else:
		state_machine.transition_to("Idle")
