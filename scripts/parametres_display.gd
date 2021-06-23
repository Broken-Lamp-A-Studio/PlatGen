extends Control


onready var time = OS.get_system_time_msecs()

func _process(_delta):
	if(OS.get_system_time_msecs() - time > 300):
		set_left(["[PlatGen Parametres view].["+MainSymlink.game_version+"]", "\n", "Memory Static Usage: %d"%OS.get_static_memory_usage(), "", "Memory Dynamic Usage: %d"%OS.get_dynamic_memory_usage(), "", "Render: "+str(OS.get_video_driver_name(OS.get_current_video_driver())), "\n--NO MORE INFORMATIONS FOUNDED--"])
		time = OS.get_system_time_msecs()

func set_left(array = []):
	$MarginContainer/UpLeft.text = ""
	for text in array:
		$MarginContainer/UpLeft.text += "\n"+text

func list_objects(array = []):
	var text = ""
	for object in array:
		text += str(object)
	return text

func _input(event):
	if(event.is_action_pressed("ui_open_close_parametres")):
		visible = not(visible)
