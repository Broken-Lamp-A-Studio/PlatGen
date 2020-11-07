extends Node2D

var maxtime
onready var time = OS.get_system_time_secs()

func _ready():
	time = OS.get_system_time_secs()

func _process(delta):
	if(OS.get_system_time_secs() - time > 20 or Input.is_key_pressed(KEY_ESCAPE)):
		get_tree().change_scene("res://scenes/gameloader.tscn")
