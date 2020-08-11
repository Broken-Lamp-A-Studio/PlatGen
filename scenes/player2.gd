extends RigidBody2D

onready var time1 = OS.get_system_time_secs()
var n = 0
var colliding = 0
var jp = false
var jump = 0
var tjump = 0
func _ready():
	self.position.x = 70
	self.position.y = 50
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
func _process(delta):
	if(jp == false):
		if(OS.get_system_time_secs() - time1 > 1):
			tjump += 1
			print("Jump time:"+"%d"%tjump)
			time1 = OS.get_system_time_secs()
		
	elif(jp == true):
		tjump = 0
		
	if(tjump > 2):
		print("Respawning...")
		self.position.x = 70
		self.position.y = 50
		jp = true
		tjump = 0
		

	
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
	jp = true
	



func _on_player_body_exited(body):
	jp = false
