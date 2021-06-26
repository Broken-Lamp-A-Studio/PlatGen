extends Control

func _process(_delta):
	$MarginContainer.rect_size = get_viewport_rect().size

func popup():
	$AnimationPlayer.stop(true)
	$AnimationPlayer.play("show_up")

func hide():
	$AnimationPlayer.stop(true)
	$AnimationPlayer.play("show_down")
