extends TextureButton


func _ready():
	set_process(true)
	set_process_input(true)
func _process(delta):
	if(self.pressed):
		get_tree().quit()
