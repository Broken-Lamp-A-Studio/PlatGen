extends TextureButton


func viewport_sync():
	rect_position.x = get_viewport_rect().size.x/5
func _process(delta):
	viewport_sync()
