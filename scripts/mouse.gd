extends Sprite


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(_delta):
	if(texture != null):
		position.x = get_global_mouse_position().x+texture.get_size().x*scale.x-15
		position.y = get_global_mouse_position().y+12#-texture.get_size().y*scale.y
