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
	
func _process(delta):
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
