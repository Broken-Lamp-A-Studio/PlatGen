extends Sprite

var radious = 300
var x = 0
var y = 0
var s = Sprite.new()
var rng = RandomNumberGenerator.new()
var childname = 0
var y2 = 0
var x2 = 0

func _ready():
	rng.randomize()

func render(px, py):
	x = px+radious
	y = py+radious
	r2(x, y)
	
func r2(bx, by):
	x2 = bx+50
	downr(x2, by)
	return(x2 == bx-radious)
	
	
func downr(fx, fy):
	childname = "background"+"%d" % OS.get_system_time_secs()
	s.name = childname
	self.add_child(s)
	get_node(childname).texture = load("res://textures/background/sky.png")
	get_node(childname).position.x = fx
	
	get_node(childname).position.y = y
	get_node(childname).visible = true
	
