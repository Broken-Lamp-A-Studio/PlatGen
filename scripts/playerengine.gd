extends Node2D


var m = false
onready var time1 = OS.get_system_time_secs()
onready var time2 = OS.get_system_time_msecs()
onready var time3 = OS.get_system_time_msecs()
var n = 0
var colliding = 0
var jp = false
var jump = 0
var tjump = 0
func _ready():
	get_node("music").playing = true
	self.position.x = 70
	self.position.y = 50
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
func _process(delta):
	if(m == true and Input.is_key_pressed(KEY_D) or m == true and Input.is_key_pressed(KEY_A)):
		get_node("dirt-walk").pla = false
	else:
		get_node("dirt-walk").pla = true
	if(OS.get_system_time_msecs() - time3 > 300):
		get_node("Camera2D/GUI").finish = false
	
	
	if(jp == false):
		if(OS.get_system_time_secs() - time1 > 1):
			tjump += 1
			print("Jump time:"+"%d"%tjump)
			time1 = OS.get_system_time_secs()
		
	elif(jp == true):
		tjump = 0
		
	if(tjump > 2):
		get_node("Camera2D/GUI").respawn = true
		print("Respawning...")
		self.position.x = 70
		self.position.y = 50
		jp = true
		tjump = 0
		get_tree().get_root().get_node("game/spawnplatform").spawn(self.position.x-300, self.position.y+300)
		time2 = OS.get_system_time_msecs()
	if(OS.get_system_time_msecs() - time2 > 300):
			get_node("Camera2D/GUI").respawn = false


	
func _physics_process(delta):
	if(Input.is_key_pressed(KEY_A)):
		self.move_local_x(-3)
	if(Input.is_key_pressed(KEY_D)):
		self.move_local_x(3)
	if not(jump == 0):
		self.move_local_y(jump)
		jump += 0.5
	if(jp == true and Input.is_key_pressed(KEY_W) or jp == true and Input.is_key_pressed(KEY_SPACE)):
		jump = -10




func _on_player_body_entered(body):
	if(body.name == "Maploader" or body.name == "ss4" or body.name == "ss3"):
		m = true
	else:
		m = false
	
	
	jp = true
	if(body.name == "star"):
		get_node("Camera2D/GUI").finish = true
		self.position.x = 70
		self.position.y = 50
		jp = true
		tjump = 0
		get_tree().get_root().get_node("game/spawnplatform").spawn(self.position.x-300, self.position.y+300)
		time3 = OS.get_system_time_msecs()



func _on_player_body_exited(body):
	jp = false
