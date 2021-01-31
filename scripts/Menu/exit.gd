extends Button


func _ready():
	set_process(true)
func _process(_delta):
	if(self.pressed):
		get_tree().quit()
