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
	if(OS.get_system_time_msecs() - textur2 > 250 and (Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_D))):
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
var t = 0
var entered_body = 0
var jump_in_execute = false
func move_body():
	if(Input.is_key_pressed(KEY_A)):
		position.x -= 5
	elif(Input.is_key_pressed(KEY_D)):
		position.x += 5
	elif((Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_SPACE)) and jump_access == true and jump_in_execute == false):
		t = 1
		jump_in_execute = true
	if(t == 1):
		if(gravity_scale > -3):
			gravity_scale -= 1.2
		elif(gravity_scale <= -3):
			gravity_scale -= 0.5
		if(gravity_scale <= -5):
			t = 2
	elif(t == 2):
		if(gravity_scale <= -1):
			gravity_scale += 0.5
		elif(gravity_scale >= -1):
			gravity_scale += 0.8
		if(gravity_scale >= 1):
			t = 0
			jump_in_execute = false
	if(entered_body > 0):
		jump_access = true
	else:
		jump_access = false

func _on_player_body_entered(body):
	entered_body += 1
	print("Touching:"+body.name)


func _on_player_body_exited(body):
	entered_body -= 1
	print("End of touching:"+body.name)

func get_stop():
	self.pause_mode = true
