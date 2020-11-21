extends Node2D

var world_name = "Unnamed"
func mouse_active():
	if(Input.is_mouse_button_pressed(BUTTON_LEFT)):
		pass
func run():
	if(get_node("start").pressed):
		make_file("user://save/save_files.data", "user://save")
		make_file("user://save/worldname.world", world_name)
		get_tree().change_scene("res://scenes/GAME.tscn")
func make_file(path, data):
	var file = File.new()
	file.open(path, File.WRITE)
	file.store_line(data)
	file.close()
func _process(delta):
	run()
	world_name = get_node("TextEdit").text
