extends Node2D

var n = 0
var colliding = 0
var jp = false
var jump = 0
func _ready():
	self.position.x = 70
	self.position.y = 50
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
func _process(delta):
	if(self.position.y >= 1000):
		self.position.x = 70
		self.position.y = 50
	
	
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
		jp = false

func _on_player_body_entered(body):
	n = body.get_name()
	print(n)
	jp = true
 
