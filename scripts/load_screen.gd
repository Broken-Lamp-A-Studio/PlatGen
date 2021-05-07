extends Node2D



func viewport_changed():
	$main_sprite.rect_size.x = get_viewport_rect().size.x
	$main_sprite.rect_size.y = get_viewport_rect().size.y
	$main_sprite.rect_position.x = 0
	$main_sprite.rect_position.y = 0
	$tip.rect_position.x = get_viewport_rect().size.x/2-$tip.rect_size.x/2
	$tip.rect_position.y = get_viewport_rect().size.y-get_viewport_rect().size.y/2.4
	$Node2D.scale.x = get_viewport_rect().size.x/1360-0.2
	$Node2D.scale.y = get_viewport_rect().size.y/768-0.2
	$Node2D.position.x = get_viewport_rect().size.x/2#-$Node2D/loading_icon.rect_size.x/2
	$Node2D.position.y = get_viewport_rect().size.y-get_viewport_rect().size.y/5
	$ProgressBar.rect_position.x = get_viewport_rect().size.x/2-$ProgressBar.rect_size.x/2
	$ProgressBar.rect_position.y = get_viewport_rect().size.y-get_viewport_rect().size.y/10
	$Label.rect_position.x = get_viewport_rect().size.x/2-$Label.rect_size.x/2
	$Label.rect_position.y = get_viewport_rect().size.y-get_viewport_rect().size.y/7

var vx = 0
var vy = 0
var in_load = false
onready var loading_anim_time = OS.get_system_time_msecs()

func _process(_delta):
	if(vx != get_viewport_rect().size.x or vy != get_viewport_rect().size.y):
		vx = get_viewport_rect().size.x
		vy = get_viewport_rect().size.y
		viewport_changed()
	if(in_load == true and OS.get_system_time_msecs() - loading_anim_time > 10):
		$Node2D.rotate(0.02)
		loading_anim_time = OS.get_system_time_msecs()
