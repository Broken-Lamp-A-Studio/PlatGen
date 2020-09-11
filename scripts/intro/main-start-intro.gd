extends Node2D

onready var time = OS.get_system_time_secs()

func _ready():
	self.visible = true
	set_process(true)
func _process(delta):
	if(OS.get_system_time_secs() - time > 7):
		self.visible = false
		get_node("background").set_process(false)
		get_node("text").set_process(false)
		set_process(false)
