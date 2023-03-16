extends PlayerState

# function to transition between states
func _get_next_state():
	pass

# is called as a _process()
func update(_delta: float) -> void:
	_get_next_state()


# is called as a _physics_process()
func physics_update(_delta: float) -> void:
	pass

# called when state is transitioned to
func enter(_msg := {}) -> void:
	pass

# called when state is transitioned from
func exit() -> void:
	pass
