extends TextureButton


func _ready():
	set_process(true)
	set_process_input(true)
func _process(delta):
	viewport_sync()
	if(self.pressed):
		get_tree().quit()
func viewport_sync():
	rect_position.x = get_viewport_rect().size.x/5
