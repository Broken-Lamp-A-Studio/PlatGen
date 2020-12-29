extends Control


func viewport_set():
	rect_position.x = get_viewport_rect().size.x-get_viewport_rect().size.x/0.82
	rect_position.y = get_viewport_rect().size.y-get_viewport_rect().size.y/0.7
func _process(delta):
	viewport_set()
