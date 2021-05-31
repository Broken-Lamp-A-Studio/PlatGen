extends Control

var vx = 0
var vy = 0
var elements = 0

onready var time = OS.get_system_time_secs()

func _process(_delta):
	if(vx != get_viewport_rect().size.x or vy != get_viewport_rect().size.y):
		viewport_changed()
		vx = get_viewport_rect().size.x
		vy = get_viewport_rect().size.y
	if(OS.get_system_time_secs() - time > 1):
		var a = "                                      Elements: %d"%elements
		$Label.text = "Memory usage: %d"%(OS.get_static_memory_usage()/1000000)+"MB"+a
		time = OS.get_system_time_secs()

func viewport_changed():
	self.rect_position.y = get_viewport_rect().size.y-rect_size.y
	rect_position.x = 0
	$background.rect_size = rect_size
	$Label.rect_size.x = get_viewport_rect().size.x
	$Label2.rect_position.x = get_viewport_rect().size.x-200
	$Label2.rect_size.x = 200
