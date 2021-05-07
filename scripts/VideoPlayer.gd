extends VideoPlayer

###CONFIG###
var version = "0.57"
var author = "GamePlayer"
var devs = ["GamePlayer"]
############

var dir = Directory.new()
onready var time = OS.get_system_time_secs()
var size
func _ready():
	
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	print("===OS informations===")
	print("OS:"+OS.get_name())
	print("Audio: %d"%OS.get_audio_driver_count())
	print("Graphics: %d"%OS.get_current_video_driver())
	print("Executable path: "+OS.get_executable_path())
	print("Working path: "+OS.get_user_data_dir())
	print("Game name: PlatGen")
	print("Version: "+version)
	print("Authors:")
	print(devs)
	print("===END===")
	print("Starting game...")
	$AnimationPlayer.play("Sprite_Animation_start")
	dir.open("user://")
	if not(dir.dir_exists("user://logs")):
		dir.make_dir("user://logs")
	if not(dir.dir_exists("user:///save")):
		dir.make_dir("user:///save")
	if not(dir.dir_exists("user://user-settings")):
		dir.make_dir("user:///user-settings")
	self.visible = true
	set_process(true)
	set_process_input(true)
var s2 = 0
var vx = 0
var vy = 0
var anim_end = false

func _process(_delta):
	if(vx != get_viewport_rect().size.x or vy != get_viewport_rect().size.y):
		vx = get_viewport_rect().size.x
		vy = get_viewport_rect().size.y
		viewport_changed()
	#print(self.str)
	
	size = stream_position
	if(s2 < size):
		s2 += 1
		print("Countdown to end animation: %d"%(10-s2))
		if(s2 >= 5 and anim_end == false):
			$AnimationPlayer.play("Sprite_Animation_end")
			anim_end = true
	#elif(s2 > size):
	#	get_tree().change_scene("res://scenes/Menu.tscn")
	if(OS.get_system_time_secs() - time > 10 or Input.is_key_pressed(KEY_ESCAPE)):
		if(Input.is_key_pressed(KEY_ESCAPE)):
			print("Countdown canceled...")
		print("Running game!")
		#self.visible = false
# warning-ignore:return_value_discarded
		self.queue_free()

func viewport_changed():
	rect_size.x = get_viewport_rect().size.x
	rect_size.y = get_viewport_rect().size.y
	self.rect_position.x = get_viewport_rect().size.x/2-rect_size.x/2
	rect_position.y = get_viewport_rect().size.y/2-rect_size.y/2
	$Sprite.position.x = get_viewport_rect().size.x - $Sprite.texture.get_size().x/4
	$Sprite.position.y = get_viewport_rect().size.y - $Sprite.texture.get_size().y/2

