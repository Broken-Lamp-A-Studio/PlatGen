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
	get_tree().get_root().get_node("Menu2/Camera2D/CanvasLayer/GUI/"+menu).get_open()

func get_menu2(menu):
	get_tree().get_root().get_node("GAME/player/CanvasLayer/GUI/"+menu).get_open()

func _process(_delta):
	animation_init()
	if(get_node("main-panel/Back").pressed):
		animation = -1
		if not(get_tree().get_root().get_node_or_null("GAME")):
			get_menu("MainMenu")
		else:
			get_menu2("Pause_menu")
