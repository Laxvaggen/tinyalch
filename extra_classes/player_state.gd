class_name PlayerState
extends State

var player: Player

@export var state_visibility_multiplier: float
@export var state_noise_multiplier: float

func _ready() -> void:
	await owner.ready
	player = owner as Player
