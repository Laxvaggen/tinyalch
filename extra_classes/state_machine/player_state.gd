class_name PlayerState
extends State

var player: Player

@export var state_visibility_multiplier: float = 1
@export var state_noise_multiplier: float = 1

func _ready() -> void:
	await owner.ready
	player = owner as Player
