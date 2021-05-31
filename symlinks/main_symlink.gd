extends Node


var console = "init/main-stuff/CenterContainer/Console Debug"

func console_output(msg, _type = "info"):
	if not(_type) or _type == "info":
		get_tree().get_root().get_node(console).get_msg(str(msg))
	elif(_type == "warn"):
		get_tree().get_root().get_node(console).get_warn(str(msg))
	elif(_type == "error" or _type == "err"):
		get_tree().get_root().get_node(console).get_error(str(msg))

var texture_editor = false
var collision_editor = false
var particle_editor = true

func set_music(array = []):
	get_tree().get_root().get_node("init/Music").set_music(array)
