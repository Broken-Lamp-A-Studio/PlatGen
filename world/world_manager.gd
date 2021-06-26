extends Node

var _object_cache = []

func _ready():
	MainSymlink.console_output("[World] Instance initialized!")

func _init_cache():
	for block in _content_pack.blocks:
		var block_dump = load(block.path).instance()
		_object_cache += [{"type":"block", "name":block_dump.name, "dump":block_dump}]
		

var _world_config = {"mode":"spectator"}
var _game_gen = []
var _game_noise_texture = OpenSimplexNoise.new()
var _game_seed = 000000
var rng = RandomNumberGenerator.new()
var _content_pack = {"blocks":[], "characters":[], "events":[]}

func _load_object(x, y):
	pass

func _initialize_object(x, y):
	var noise = _game_noise_texture.get_noise_2d(x, y)
	var biomes_tick = 0
	var biomes = []
	for biome_cfg in _game_gen[1].biomes_meta:
		if(noise > biome_cfg.render.noise.min and biome_cfg.render.noise.max > noise):
			if(biome_cfg.render.zone.x.min != 0 and biome_cfg.render.zone.x.max != 0):
				if(biome_cfg.render.zone.y.min != 0 and biome_cfg.render.zone.y.max != 0):
					if(x > biome_cfg.render.zone.x.min and x < biome_cfg.render.zone.x.max and y > biome_cfg.render.zone.y.min and y < biome_cfg.render.zone.y.max):
						biomes += [biomes_tick]
				else:
					if(x > biome_cfg.render.zone.x.min and x < biome_cfg.render.zone.x.max):
						biomes += [biomes_tick]
			else:
				if(biome_cfg.render.zone.y.min != 0 and biome_cfg.render.zone.y.max != 0):
					if(y > biome_cfg.render.zone.y.min and y < biome_cfg.render.zone.y.max):
						biomes += [biomes_tick]
				else:
					biomes += [biomes_tick]
		biomes_tick += 1
	
	if(biomes.size() > 0):
		var biome_select = biomes[round(rng.randf_range(0, biomes.size()-1))]
		
		
		var objects_tick = 0
		var objects = []
		for object_cfg in _game_gen[1].objects_meta:
			if(Array(object_cfg.biomes).has(biome_select)):
				if(noise > object_cfg.render.pos.min and object_cfg.render.pos.max > noise):
					if(object_cfg.render.height.max.bool):
						if(y < object_cfg.render.height.max.value):
							if(object_cfg.render.height.min.bool):
								if(y > object_cfg.render.height.min.value):
									if(object_cfg.render.width.max.bool):
										if(x < object_cfg.render.width.max.value):
											if(object_cfg.render.width.min.bool):
												if(x > object_cfg.render.width.min.value):
													objects += [objects_tick]
											else:
												objects += [objects_tick]
									else:
										if(object_cfg.render.width.min.bool):
											if(x > object_cfg.render.width.min.value):
												objects += [objects_tick]
										else:
											objects += [objects_tick]
							else:
								if(object_cfg.render.width.max.bool):
									if(x < object_cfg.render.width.max.value):
										if(object_cfg.render.width.min.bool):
											if(x > object_cfg.render.width.min.value):
												objects += [objects_tick]
										else:
											objects += [objects_tick]
								else:
									if(object_cfg.render.width.min.bool):
										if(x > object_cfg.render.width.min.value):
											objects += [objects_tick]
									else:
										objects += [objects_tick]
					else:
						if(object_cfg.render.height.min.bool):
							if(y > object_cfg.render.height.min.value):
								if(object_cfg.render.width.max.bool):
									if(x < object_cfg.render.width.max.value):
										if(object_cfg.render.width.min.bool):
											if(x > object_cfg.render.width.min.value):
												objects += [objects_tick]
										else:
											objects += [objects_tick]
								else:
									if(object_cfg.render.width.min.bool):
										if(x > object_cfg.render.width.min.value):
											objects += [objects_tick]
									else:
										objects += [objects_tick]
						else:
							if(object_cfg.render.width.max.bool):
								if(x < object_cfg.render.width.max.value):
									if(object_cfg.render.width.min.bool):
										if(x > object_cfg.render.width.min.value):
											objects += [objects_tick]
									else:
										objects += [objects_tick]
							else:
								if(object_cfg.render.width.min.bool):
									if(x > object_cfg.render.width.min.value):
										objects += [objects_tick]
								else:
									objects += [objects_tick]
			objects_tick += 1
		if(objects.size() > 0):
			var object_select = objects[round(rng.randf_range(0, objects.size()-1))]
			return _game_gen[1].objects_meta[object_select].path
		else:
			return null
	else:
		return null
