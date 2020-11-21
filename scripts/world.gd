extends Node2D

var game_path = ""
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
var px7 = 0
var py7 = 0
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
	if(game_path != "" and chunk_gen_run == true):
		chunk_player_gen()
	#VM_chunk_sync()
	viewport_changed()
	VM_micro_chunk()
	#if(chunk_gen_run == true):
	#	chunk_player_gen()
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
		get_node(n).game_path = game_path
		get_node(n).setup(n2, n, texture2, gui2, effects2, collision, light, x, y)
		
	else:
		get_node(n).game_path = game_path
		get_node(n).setup(n2, n, texture2, gui2, effects2, collision, light, x, y)
		
func layer_0(x, y): #layer of blocks, in tests
	var texture_type = round(rng.randf_range(0, 3))
	add_block(block_names[texture_type], block_list[texture_type], false, false, true, false, x, y)
func chunk_gen(x, y):
	if not(get_node_or_null("%d"%x+"%d"%y)):
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
	var rand1 = round(rng.randf_range(0, 1))
	if(rand1 == 1 and access == true):
		add_block("air", "", false, false, false, false, x, y)
		
var progress = 0
var chunk_load_type = 1
func chunk_player_gen():
	if(get_tree().get_root().get_node("GAME/player/GUI/l").visible == false):
		get_tree().get_root().get_node("GAME/player/GUI/l").visible2()
	if not(get_node_or_null("%d"%(px2-200+VM_chunk_X)+"%d"%(py2-200+VM_chunk_Y))):
		#print("Make chunk:%d"%(px2-200+VM_chunk_X)+"%d"%(py2-200+VM_chunk_Y))
		chunk_gen(px2-200+VM_chunk_X, py2-200+VM_chunk_Y)
	if not(get_node_or_null("%d"%(px2-200+VM_chunk_X+chunk_size)+"%d"%(py2-200+VM_chunk_Y+chunk_size))):
		#print("Make chunk:%d"%(px2-200+VM_chunk_X+chunk_size)+"%d"%(py2-200+VM_chunk_Y+chunk_size))
		chunk_gen(px2-200+VM_chunk_X+chunk_size, py2-200+VM_chunk_Y+chunk_size)
	if not(get_node_or_null("%d"%(px2-200+VM_chunk_X-chunk_size)+"%d"%(py2-200+VM_chunk_Y+chunk_size))):
		#print("Make chunk:%d"%(px2-200+VM_chunk_X-chunk_size)+"%d"%(py2-200+VM_chunk_Y+chunk_size))
		chunk_gen(px2-200+VM_chunk_X-chunk_size, py2-200+VM_chunk_Y+chunk_size)
	if not(get_node_or_null("%d"%(px2-200+VM_chunk_X+chunk_size)+"%d"%(py2-200+VM_chunk_Y-chunk_size))):
		#print("Make chunk:%d"%(px2-200+VM_chunk_X+chunk_size)+"%d"%(py2-200+VM_chunk_Y-chunk_size))
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
	progress += 0.8
	if(px2 > 500):
		py2 += 50
		px2 = 0
		
	
	if(py2 > 500):
		py2 = 0
		progress = 100
		chunk_gen_run = false
		get_tree().get_root().get_node("GAME/player").set_process(true)
		get_tree().get_root().get_node("GAME/player").set_physics_process(true)
		get_tree().get_root().get_node("GAME/player").gravity_scale = 1
		get_tree().get_root().get_node("GAME/player/GUI/l").unvisible()
		get_tree().get_root().get_node("GAME/player/helmet-light").enabled = true
	get_tree().get_root().get_node("GAME/player/GUI/l").change_progress("Generating world...", "set", progress)
var VM_m_x = 0
var VM_m_y = 0
var block_size = 50
var time_of_return = 0
var ttt = ""
func VM_micro_chunk():
	var px = get_tree().get_root().get_node("GAME/player").position.x
	var py = get_tree().get_root().get_node("GAME/player").position.y
	if(px > VM_m_x+block_size/2):
		VM_m_x += block_size
		load_2_chunk("+x")
	if(px < VM_m_x-block_size/2):
		VM_m_x -= block_size
		load_2_chunk("-x")
	if(py > VM_m_y+block_size/2):
		VM_m_y += block_size
		load_2_chunk("+y")
	if(py < VM_m_y-block_size/2):
		VM_m_y -= block_size
		load_2_chunk("-y")
var x2 = 0
var y2 = 0
var t2 = ""
var t3 = 0
var t4 = 0
func load_2_chunk(direction):
	ttt = direction
	t3 = rng.randf_range(-9999, 9999)
	if(direction == "+x" or direction == "-x"):
		time_of_return = round(get_viewport_rect().size.y/50)
	if(direction == "+y" or direction == "-y"):
		time_of_return = round(get_viewport_rect().size.x/50)
	while not(time_of_return == 0):
			time_of_return -= 1
			if(ttt == "+x"):
				if(ttt != t2 or t3 != t4):
					t2 = ttt
					t4 = t3
					y2 = VM_m_y
				y2 += 50
				#print("+X: %d"%(VM_m_x+50*round(get_viewport_rect().size.x/50))+"-!-%d"%(y2-50*round(get_viewport_rect().size.y/50)))
				chunk_gen(VM_m_x+(50*round(get_viewport_rect().size.x/2/50)), y2-(50*round(get_viewport_rect().size.y/2/50)))
			if(ttt == "-x"):
				if(ttt != t2 or t3 != t4):
					t2 = ttt
					t4 = t3
					y2 = VM_m_y
				y2 += 50
				#print("-X: %d"%(VM_m_x-50*round(get_viewport_rect().size.x/50))+"-!-%d"%(y2-50*round(get_viewport_rect().size.y/50)))
				chunk_gen(VM_m_x-(50*round(get_viewport_rect().size.x/2/50)), y2-(50*round(get_viewport_rect().size.y/2/50)))
			if(ttt == "+y"):
				if(ttt != t2 or t3 != t4):
					t2 = ttt
					t4 = t3
					x2 = VM_m_x
				x2 += 50
				#print("+Y: %d"%(x2-50*round(get_viewport_rect().size.x/50))+"-!-%d"%(VM_m_y+50*round(get_viewport_rect().size.y/50)))
				chunk_gen(x2-(50*round(get_viewport_rect().size.x/2/50)), VM_m_y+(50*round(get_viewport_rect().size.y/2/50)))
			if(ttt == "-y"):
				if(ttt != t2 or t3 != t4):
					t2 = ttt
					t4 = t3
					x2 = VM_m_x
				x2 += 50
				#print("-Y: %d"%(x2-50*round(get_viewport_rect().size.x/50))+"-!-%d"%(VM_m_y-50*round(get_viewport_rect().size.y/50)))
				chunk_gen(x2-(50*round(get_viewport_rect().size.x/2/50)), VM_m_y-(50*round(get_viewport_rect().size.y/2/50)))
	ttt = ""
