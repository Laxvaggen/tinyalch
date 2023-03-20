extends PlayerState

func fury_fists() -> void:
	pass

func magma_shot() -> void:
	pass

func rage() -> void:
	pass

func heal() -> void:
	pass

func quick_slashes() -> void:
	pass

func water_spear() -> void:
	pass

func wave_slam() -> void:
	pass

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
	pass

# called when state is transitioned from
func exit():
	pass

