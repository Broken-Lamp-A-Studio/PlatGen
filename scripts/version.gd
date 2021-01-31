extends Label



func _process(_delta):
	self.rect_position.x = get_viewport_rect().size.x-200
	self.rect_position.y = get_viewport_rect().size.y-25
