extends Control

var animation = 0
onready var time = OS.get_system_time_msecs()

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

func _process(_delta):
	if(get_node("play").pressed):
		animation = -1
		get_menu("Singleplayer")
	if(get_node("options").pressed):
		animation = -1
		get_menu("Options")
	animation_init()

func get_open():
	animation = 1

func get_menu(menu):
	get_tree().get_root().get_node("Menu2/Camera2D/CanvasLayer/GUI/"+menu).get_open()
