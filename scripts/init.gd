extends Node2D

var vx = 0
var vy = 0


func set_main_cam(config2):
	$Camera2D.current = config2

func _process(_delta):
	if(vx != get_viewport_rect().size.x or vy != get_viewport_rect().size.y):
		vx = get_viewport_rect().size.x
		vy = get_viewport_rect().size.y
		viewport_changed()

func viewport_changed():
	$Camera2D.position.x = get_viewport_rect().size.x/2
	$Camera2D.position.y = get_viewport_rect().size.y/2
	if(get_node_or_null("VideoPlayer")):
		get_node("VideoPlayer").rect_position.x = get_viewport_rect().size.x/2-get_node("VideoPlayer").rect_size.x/2
		get_node("VideoPlayer").rect_position.y = get_viewport_rect().size.y/2-get_node("VideoPlayer").rect_size.y/2

