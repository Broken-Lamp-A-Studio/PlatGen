extends VideoPlayer


onready var time = OS.get_system_time_secs()

func _ready():
	self.visible = true
	set_process(true)
	set_process_input(true)
func _process(delta):
	if(OS.get_system_time_secs() - time > 18 or Input.is_key_pressed(KEY_ESCAPE)):
		self.visible = false
		get_tree().change_scene("res://scenes/Menu.tscn")
		set_process(false)
		set_process_input(false)
