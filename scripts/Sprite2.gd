extends Sprite

var type = 0
onready var time = OS.get_system_time_msecs()
func viewport_sync():
	position.y = get_viewport_rect().size.y-self.texture.get_size().y
	position.x = get_viewport_rect().size.x-self.texture.get_size().x/1.2
func _ready():
	vframes = 10
	set_process(true)
	self.visible = true
	self.modulate.a = 0
func animation():
	if(OS.get_system_time_msecs() - time > 50 and type != 1 and type != 3):
		if(type == 0):
			if(vframes > 5):
				self.modulate.a += 0.1
				vframes -= 1
			elif(vframes > 3):
				vframes -= 0.5
				self.modulate.a += 0.05
			elif(vframes > 1):
				vframes -= 0.1
				self.modulate.a += 0.01
			elif(vframes == 1):
				type = 1
		elif(type == 2):
			if(vframes < 8):
				vframes += 1
				self.modulate.a -= 0.1
			elif(vframes < 10):
				type = 3
				self.visible = false
				set_process(false)
		time = OS.get_system_time_msecs()
	if(OS.get_system_time_msecs() - time > 2000 and type != 3):
		type = 2
		time = OS.get_system_time_msecs()
func _process(delta):
	viewport_sync()
	animation()
