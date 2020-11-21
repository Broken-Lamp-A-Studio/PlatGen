extends TextureRect


func viewport_sync():
	rect_position.x = get_viewport_rect().size.x/20
	rect_position.y = get_viewport_rect().size.y-(3*(get_viewport_rect().size.y/3))
func _process(delta):
	viewport_sync()
