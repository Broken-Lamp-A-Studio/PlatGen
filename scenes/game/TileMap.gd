extends TileMap

var cells = self.get_used_cells()
var multix = 0
var multiy = 0
var x = 0
var y = 0
var wielkoscx = self.cell_size.x
var wielkoscy = self.cell_size.y

func _ready():
	x = multix
	y = multiy
	self.position.x = x
	self.position.y = y
	set_process(true)
	
func _physics_process(delta):
	multix = get_tree().get_root().get_node("GAME/player").position.x
	multiy = get_tree().get_root().get_node("GAME/player").position.y
	if(multix - x <= -wielkoscx):
		x -= wielkoscx
	if(multix - x >= wielkoscx):
		x += wielkoscx
	if(multiy - y <= -wielkoscy):
		y -= wielkoscy
	if(multiy - y >= wielkoscy):
		y += wielkoscy
	self.position.x = x
	self.position.y = y
