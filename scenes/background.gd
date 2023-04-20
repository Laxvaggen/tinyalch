extends ColorRect

# Always follows current camera


func _ready():
	custom_minimum_size = get_viewport().size



func _process(_delta):
	position = get_viewport().get_camera_2d().get_screen_center_position() - Vector2(get_viewport_rect().size)/2
