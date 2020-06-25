extends Node2D

onready var last_time = OS.get_system_time_secs()
var type = false
onready var time = OS.get_system_time_msecs()
const SPEED = 0.8
var GRAVITY = 0.5
const JUMP = -5
var rotate2 = 1
var g2 = 2
var ff = 0
var adder = 0
var t = 0
var colliding = false
func _ready():
	set_process(false)
	set_process_input(false)
	

	
func _physics_process(delta):
	if(colliding == true):
		if(Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_SPACE)):
			self.position.y += JUMP
	self.position.y += GRAVITY
	if(Input.is_key_pressed(KEY_D)):
		rotate2 = 1
		self.position.x += SPEED
		g2 = 4
	if(Input.is_key_pressed(KEY_A)):
		rotate2 = 2
		self.position.x -= SPEED
		g2 = 3
	if(self.position.y >= 60):
		self.position.y -= GRAVITY
	
	
func _process(delta):
	if(OS.get_system_time_secs() - last_time > 0.1):
		type = not type
		last_time = OS.get_system_time_secs()
	if(rotate2 == 1):
		if(type == true and Input.is_key_pressed(KEY_D)):
			get_node("player/Sprite").texture = load("res://textures/player/right-1.png")
		if(type == false and Input.is_key_pressed(KEY_D)):
			get_node("player/Sprite").texture = load("res://textures/player/right-2.png")
	if(rotate2 == 2):
		if(type == true and Input.is_key_pressed(KEY_A)):
			get_node("player/Sprite").texture = load("res://textures/player/left-1.png")
		if(type == false and Input.is_key_pressed(KEY_A)):
			get_node("player/Sprite").texture = load("res://textures/player/left-2.png")

	
