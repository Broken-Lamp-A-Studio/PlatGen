extends Node


var console = "init/main-stuff/CenterContainer/Console Debug"

func console_output(msg, _type):
	if not(_type) or _type == "info":
		get_tree().get_root().get_node(console).get_msg(msg)
	elif(_type == "warn"):
		get_tree().get_root().get_node(console).get_warn(msg)
	elif(_type == "error" or _type == "err"):
		get_tree().get_root().get_node(console).get_error(msg)

var texture_editor = false
var collision_editor = true
var collision_list = []
