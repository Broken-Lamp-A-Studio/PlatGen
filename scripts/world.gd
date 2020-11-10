extends Node2D

var worldelement = load("res://worldelement.tscn")
var chunk_gen = null
var x4 = 0
var y5 = 0
var block_list = [
	"res://textures/map/default/dirt_with_grass.png",
	"res://textures/map/default/cobble_1.png",
	"res://textures/map/default/stone_1.png",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	""
	]
var block_names = [
	"dirt_with_grass",
	"cobble_1",
	"stone_1",
	"air",
	"air",
	"air",
	"air",
	"air",
	"air",
	"air",
	"air",
	"air"
]
var posx = 50
var px2 = 0
var py2 = 0
var posy = 0
var rng = RandomNumberGenerator.new()
var VM_chunk_X = 0
var VM_chunk_Y = 0
var chunk_limit = 1
var chunk_size = 500
var chunk_gen_run = true
var view_x = 0
var view_y = 0
var VM_player_X = 0
var VM_player_Y = 0
func VM_player():
	var px = get_tree().get_root().get_node("GAME/player").position.x
	var py = get_tree().get_root().get_node("GAME/player").position.y
	if(px - VM_player_X> 50):
		VM_player_X += 50
	elif(px - VM_player_X < -50):
		VM_player_X -= 50
	if(py - VM_player_Y> 50):
		VM_player_X += 50
	elif(py - VM_player_Y < -50):
		VM_player_X -= 50
var px7 = 0
var py7 = 0
func smart_rend(direction):
	pass
func viewport_changed():
	if not(view_x == get_viewport_rect().size.x):
		view_x = get_viewport_rect().size.x
		chunk_gen_run = true
	if not(view_y == get_viewport_rect().size.y):
		view_y = get_viewport_rect().size.y
		chunk_gen_run = true
func _ready():
	rng.randomize()
onready var time5 = OS.get_system_time_secs()
func _process(delta):
	VM_chunk_sync()
	viewport_changed()
	if(chunk_gen_run == true):
		chunk_player_gen()
func VM_chunk_sync():
	var px = get_tree().get_root().get_node("GAME/player").position.x
	var py = get_tree().get_root().get_node("GAME/player").position.y
	if(px > (VM_chunk_X+chunk_size/2) and px > (VM_chunk_X-chunk_size/2)):
		VM_chunk_X += chunk_size
		px2 = 0
		py2 = 0
		chunk_gen_run = true
	if(px < (VM_chunk_X+chunk_size/2) and px < (VM_chunk_X-chunk_size/2)):
		VM_chunk_X -= chunk_size
		px2 = 0
		py2 = 0
		chunk_gen_run = true
	if(py > (VM_chunk_Y+chunk_size/2) and py > (VM_chunk_Y-chunk_size/2)):
		VM_chunk_Y += chunk_size
		px2 = 0
		py2 = 0
		chunk_gen_run = true
	if(py < (VM_chunk_Y+chunk_size/2) and py < (VM_chunk_Y-chunk_size/2)):
		VM_chunk_Y -= chunk_size
		px2 = 0
		py2 = 0
		chunk_gen_run = true
func add_block(name2, texture2, gui2, effects2, collision, light, x, y):
	var n2 = name2
	#if not(x > (50+get_viewport_rect().size.x/2+get_tree().get_root().get_node("GAME/player").position.x) or x < (50-get_tree().get_root().get_node("GAME/player").position.x-get_viewport_rect().size.x/2) or y > (50+get_viewport_rect().size.y/2+get_tree().get_root().get_node("GAME/player").position.y) or y < (50-get_tree().get_root().get_node("GAME/player").position.y-get_viewport_rect().size.y/2)):
	var n = "%d"%x+"%d"%y
	if not(get_node_or_null("%d"%x+"%d"%y)):
		var obj = worldelement.instance()
		obj.name = n
		self.add_child(obj) #get_node("%d"%chunk)
		get_node(n).setup(n2, n, texture2, gui2, effects2, collision, light, x, y)
	else:
		get_node(n).setup(n2, n, texture2, gui2, effects2, collision, light, x, y)
		print("replace: %d"%x+":%d"%y)
func layer_0(x, y): #layer of blocks, in tests
	var texture_type = round(rng.randf_range(0, 3))
	add_block(block_names[texture_type], block_list[texture_type], false, false, true, false, x, y)
func chunk_gen(x, y):
	layer_0(x, y)
	layer_1(x, y)
var active_mapgen = []
func layer_1(x, y):
	var access = false
	if(get_node_or_null("%d"%(x+50)+"%d"%y)):
		if(get_node_or_null("%d"%(x+50)+"%d"%y).node == "air"):
			access = true
	if(get_node_or_null("%d"%(x-50)+"%d"%y)):
		if(get_node_or_null("%d"%(x-50)+"%d"%y).node == "air"):
			access = true
	if(get_node_or_null("%d"%x+"%d"%(y-50))):
		if(get_node_or_null("%d"%x+"%d"%(y-50)).node == "air"):
			access = true
	var rand1 = round(rng.randf_range(0, 2))
	if(rand1 == 1 and access == true):
		add_block("air", "", false, false, false, false, x, y)
		

var chunk_load_type = 1
func chunk_player_gen():
	if not(get_node_or_null("%d"%(px2-200+VM_chunk_X)+"%d"%(py2-200+VM_chunk_Y))):
		print("Make chunk:%d"%(px2-200+VM_chunk_X)+"%d"%(py2-200+VM_chunk_Y))
		chunk_gen(px2-200+VM_chunk_X, py2-200+VM_chunk_Y)
	if not(get_node_or_null("%d"%(px2-200+VM_chunk_X+chunk_size)+"%d"%(py2-200+VM_chunk_Y+chunk_size))):
		print("Make chunk:%d"%(px2-200+VM_chunk_X+chunk_size)+"%d"%(py2-200+VM_chunk_Y+chunk_size))
		chunk_gen(px2-200+VM_chunk_X+chunk_size, py2-200+VM_chunk_Y+chunk_size)
	if not(get_node_or_null("%d"%(px2-200+VM_chunk_X-chunk_size)+"%d"%(py2-200+VM_chunk_Y+chunk_size))):
		print("Make chunk:%d"%(px2-200+VM_chunk_X-chunk_size)+"%d"%(py2-200+VM_chunk_Y+chunk_size))
		chunk_gen(px2-200+VM_chunk_X-chunk_size, py2-200+VM_chunk_Y+chunk_size)
	if not(get_node_or_null("%d"%(px2-200+VM_chunk_X+chunk_size)+"%d"%(py2-200+VM_chunk_Y-chunk_size))):
		print("Make chunk:%d"%(px2-200+VM_chunk_X+chunk_size)+"%d"%(py2-200+VM_chunk_Y-chunk_size))
		chunk_gen(px2-200+VM_chunk_X+chunk_size, py2-200+VM_chunk_Y-chunk_size)
	if not(get_node_or_null("%d"%(px2-200+VM_chunk_X)+"%d"%(py2-200+VM_chunk_Y+chunk_size))):
		chunk_gen(px2-200+VM_chunk_X, py2-200+VM_chunk_Y+chunk_size)
	if not(get_node_or_null("%d"%(px2-200+VM_chunk_X-chunk_size)+"%d"%(py2-200+VM_chunk_Y))):
		chunk_gen(px2-200+VM_chunk_X-chunk_size, py2-200+VM_chunk_Y)
	if not(get_node_or_null("%d"%(px2-200+VM_chunk_X+chunk_size)+"%d"%(py2-200+VM_chunk_Y))):
		chunk_gen(px2-200+VM_chunk_X+chunk_size, py2-200+VM_chunk_Y)
	if not(get_node_or_null("%d"%(px2-200+VM_chunk_X)+"%d"%(py2-200+VM_chunk_Y-chunk_size))):
		chunk_gen(px2-200+VM_chunk_X, py2-200+VM_chunk_Y-chunk_size)
	if not(get_node_or_null("%d"%(px2-200+VM_chunk_X-chunk_size)+"%d"%(py2-200+VM_chunk_Y-chunk_size))):
		chunk_gen(px2-200+VM_chunk_X-chunk_size, py2-200+VM_chunk_Y-chunk_size)
	
	if not(get_node_or_null("%d"%(px2-200+VM_chunk_X+chunk_size*2)+"%d"%(py2-200+VM_chunk_Y+chunk_size*2))):
		chunk_gen(px2-200+VM_chunk_X+chunk_size*2, py2-200+VM_chunk_Y+chunk_size*2)
	if not(get_node_or_null("%d"%(px2-200+VM_chunk_X-chunk_size*2)+"%d"%(py2-200+VM_chunk_Y+chunk_size*2))):
		chunk_gen(px2-200+VM_chunk_X-chunk_size*2, py2-200+VM_chunk_Y+chunk_size*2)
	if not(get_node_or_null("%d"%(px2-200+VM_chunk_X+chunk_size*2)+"%d"%(py2-200+VM_chunk_Y-chunk_size*2))):
		chunk_gen(px2-200+VM_chunk_X+chunk_size*2, py2-200+VM_chunk_Y-chunk_size*2)
	if not(get_node_or_null("%d"%(px2-200+VM_chunk_X)+"%d"%(py2-200+VM_chunk_Y+chunk_size*2))):
		chunk_gen(px2-200+VM_chunk_X, py2-200+VM_chunk_Y+chunk_size*2)
	if not(get_node_or_null("%d"%(px2-200+VM_chunk_X-chunk_size*2)+"%d"%(py2-200+VM_chunk_Y))):
		chunk_gen(px2-200+VM_chunk_X-chunk_size*2, py2-200+VM_chunk_Y)
	if not(get_node_or_null("%d"%(px2-200+VM_chunk_X+chunk_size*2)+"%d"%(py2-200+VM_chunk_Y))):
		chunk_gen(px2-200+VM_chunk_X+chunk_size*2, py2-200+VM_chunk_Y)
	if not(get_node_or_null("%d"%(px2-200+VM_chunk_X)+"%d"%(py2-200+VM_chunk_Y-chunk_size*2))):
		chunk_gen(px2-200+VM_chunk_X, py2-200+VM_chunk_Y-chunk_size*2)
	if not(get_node_or_null("%d"%(px2-200+VM_chunk_X-chunk_size*2)+"%d"%(py2-200+VM_chunk_Y-chunk_size*2))):
		chunk_gen(px2-200+VM_chunk_X-chunk_size*2, py2-200+VM_chunk_Y-chunk_size*2)
	px2 += 50
	if(px2 > 500):
		py2 += 50
		px2 = 0
	if(py2 > 500):
		py2 = 0
		chunk_gen_run = false
