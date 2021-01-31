extends Control


var animation = 0
onready var time = OS.get_system_time_msecs()

func _ready():
	self.visible = false
	self.modulate.a = 0

func undo_animation_process():
	if(OS.get_system_time_msecs() - time > 10):
		if not(self.modulate.a <= 0):
			self.modulate.a -= 0.05
		else:
			animation = 0
			self.visible = false
		time = OS.get_system_time_msecs()

func animation_process():
	if(OS.get_system_time_msecs() - time > 10):
		if not(self.modulate.a > 1):
			self.visible = true
			self.modulate.a += 0.05
		else:
			animation = 0
		time = OS.get_system_time_msecs()

func animation_init():
	if(animation == -1):
		undo_animation_process()
	elif(animation == 1):
		animation_process()

func get_open():
	animation = 1

func get_menu(menu):
	get_tree().get_root().get_node("GAME/player/CanvasLayer/GUI/"+menu).get_open()

onready var time2 = OS.get_system_time_msecs()

func _process(_delta):
	animation_init()
	pos()
	if($Panel/Resume.pressed):
		animation = -1
		get_tree().get_root().get_node("GAME").game_play()
	if(Input.is_key_pressed(KEY_ESCAPE) and OS.get_system_time_msecs() - time2 > 300):
		get_tree().get_root().get_node("GAME").game_stop()
		animation = 1
		time2 = OS.get_system_time_msecs()
	if($Panel/Options.pressed):
		get_menu("Options")
		animation = -1
	if($Panel/savequit.pressed):
		get_tree().change_scene("res://scenes/Menu2.tscn")

func pos():
	rect_position.x = get_viewport_rect().size.x/2
	rect_position.y = get_viewport_rect().size.y/2
