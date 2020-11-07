extends Node2D




func _ready():
	set_process(true)
	
func _process(delta):
	if(get_node("Control/TextureButton").pressed):
		OS.shell_open("https://discord.gg/4Qg3xet")
