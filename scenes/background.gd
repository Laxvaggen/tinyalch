extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready():
	custom_minimum_size = get_viewport().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	position = get_viewport().get_camera_2d().get_screen_center_position() - Vector2(get_viewport_rect().size)/2
