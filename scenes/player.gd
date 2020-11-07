extends RigidBody2D

onready var textur2 = OS.get_system_time_msecs()
var textur3 = 1
var m = 1
var jump_access = false
onready var time = OS.get_system_time_secs()
onready var time2 = OS.get_system_time_msecs()

func change_texture():
	var mx = get_global_mouse_position().x
	var my = get_global_mouse_position().y
	if not(Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_D)):
		m = 1
	if(OS.get_system_time_msecs() - textur2 > 500 and (Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_D))):
		m += 1
		if(m > 2):
			m = 1
		textur2 = OS.get_system_time_msecs()
	if(mx>position.x):
		if(my>position.y):
			get_node("Sprite").texture = load("res://textures/player/right-%d"%m+".png")
		elif(my<position.y):
			get_node("Sprite").texture = load("res://textures/player/right-%d"%(m+2)+".png")
	elif(mx<position.x):
		if(my>position.y):
			get_node("Sprite").texture = load("res://textures/player/left-%d"%m+".png")
		elif(my<position.y):
			get_node("Sprite").texture = load("res://textures/player/left-%d"%(m+2)+".png")
func _physics_process(delta):
	change_texture()
	#if(OS.get_system_time_secs() - time > 5):
	move_body()
	light()
func light():
	get_node("helmet-light").rotation = 3.15+(get_global_mouse_position() - self.position).angle()
var jump_sys = false
func move_body():
	if(Input.is_key_pressed(KEY_A)):
		position.x -= 5
	elif(Input.is_key_pressed(KEY_D)):
		position.x += 5
	elif((Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_SPACE)) and jump_access == true):
		gravity_scale = -5
		self.position.y -= 5
		jump_sys = true
	if(jump_sys == true and OS.get_system_time_msecs() - time2 > 10):
		if not(gravity_scale >= 1):
			if(gravity_scale < 0):
				gravity_scale += 1
			else:
				gravity_scale += 0.1
		else:
			jump_sys = false
		time2 = OS.get_system_time_msecs()


func _on_player_body_entered(body):
	jump_access = true
	


func _on_player_body_exited(body):
	jump_access = false
#onready var time5 = OS.get_system_time_secs()
#func _process(delta):
#	if(OS.get_system_time_secs() - time5 > 5):
#		self.gravity_scale = 1
#		set_physics_process(true)
#	else:
##		self.gravity_scale = 0
#		set_physics_process(false)
