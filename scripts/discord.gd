extends Node2D

func viewport_sync():
	position.x = get_viewport_rect().size.x-400
	position.y = get_viewport_rect().size.y-120


func _ready():
	set_process(true)
	
func _process(delta):
	#viewport_sync()
	if(get_node("Control/TextureButton").pressed):
		OS.shell_open("https://discord.gg/4Qg3xet")
