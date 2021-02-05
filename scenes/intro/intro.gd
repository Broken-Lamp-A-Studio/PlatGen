extends Node2D

var maxtime
onready var time = OS.get_system_time_secs()

func _ready():
	time = OS.get_system_time_secs()

func _process(_delta):
	if(OS.get_system_time_secs() - time > 20 or Input.is_key_pressed(KEY_ESCAPE)):
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://scenes/GAME.tscn")

func expand_video(x, y):
	$VideoPlayer.rect_position.x = x+$VideoPlayer.margin_left/2*$VideoPlayer.rect_scale.x
	$VideoPlayer.rect_position.y = y+$VideoPlayer.margin_top/2*$VideoPlayer.rect_scale.y
	$VideoPlayer.rect_scale.x = get_viewport_rect().size.x/2
	$VideoPlayer.rect_scale.y = get_viewport_rect().size.y/2
