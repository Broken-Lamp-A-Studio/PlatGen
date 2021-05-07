extends Control

var vx = 0
var vy = 0

func _process(delta):
	if(vx != get_viewport_rect().size.x or vy != get_viewport_rect().size.y):
		viewport_changed()
		vx = get_viewport_rect().size.x
		vy = get_viewport_rect().size.y

func viewport_changed():
	#print("pip")
	$background.rect_size = self.rect_size
	$icon.rect_position.x = rect_position.x#+$icon.texture.get_size().x/10
	$icon.rect_position.y = rect_position.y#+$icon.texture.get_size().y/10
	$name.rect_position.x = rect_position.x+$icon.texture.get_size().x
	$name.rect_position.y = rect_position.y+$icon.texture.get_size().y/10
	$name.rect_size.y = rect_size.y-rect_size.y/10
	$exit.rect_position.x = get_viewport_rect().size.x-$exit.rect_size.x-10
	$exit.rect_position.y = 10
	$background_settings.rect_position.x = get_viewport_rect().size.x-$background_settings.rect_size.x-10*2-$exit.rect_size.x
	$background_settings.rect_position.y = 10
	$save.rect_position.x = get_viewport_rect().size.x-$save.rect_size.x-10*3-($background_settings.rect_size.x*2)
	$save.rect_position.y = 10
	$save_as.rect_position.x = get_viewport_rect().size.x-$save_as.rect_size.x-10*4-($save.rect_size.x*3)
	$save_as.rect_position.y = 10
	$load.rect_position.x = get_viewport_rect().size.x-$load.rect_size.x-(10+$save_as.rect_size.x)*4-10
	$load.rect_position.y = 10

func _on_exit_pressed():
	get_tree().change_scene("res://scenes/Menu2.tscn")
