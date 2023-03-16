extends Control

func _ready():
	get_viewport().connect("size_changed", Callable(self, "set_to_viewport"))
	custom_minimum_size = get_viewport_rect().size

func set_to_viewport() -> void: 
	custom_minimum_size = get_viewport_rect().size
