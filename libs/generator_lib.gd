extends Node

var env_textures = []
var env2_texture = OpenSimplexNoise.new()

func _process(_delta):
	_render_noise_process()
	_multiple_render_process()

func get_gen_pos(array_position = 0, noise_position = Vector2(1.0, 1.0)):
	var noise_texture = env_textures[array_position]
	return noise_texture.get_noise_2d(noise_position)

func make_gen(seed2 = 0000, octaves = 4, period = 20.0, persistence = 0.8, texture = OpenSimplexNoise.new()):
	env2_texture = texture
	env2_texture.seed = seed2
	env2_texture.octaves = octaves
	env2_texture.period = period
	env2_texture.persistence = persistence
	env_textures += [env2_texture]
	return env_textures.size()-1

func make_multiple_gens(array = []):
	for array_part in array:
		make_gen(array_part.seed, array_part.octaves, array_part.period, array_part.persistence)

func clear_gen_buffor():
	env_textures = []

func load_new_ones(array = []):
	clear_gen_buffor()
	make_multiple_gens(array)

func get_gen_texture(seed2 = 0000, octaves = 4, period = 20.0, persistence = 0.8, texture = OpenSimplexNoise.new()):
	env2_texture = texture
	env2_texture.seed = seed2
	env2_texture.octaves = octaves
	env2_texture.period = period
	env2_texture.persistence = persistence
	return env2_texture



func get_multinoise_texture(array = []):
	var noise_list = []
	for config in array:
		noise_list += [get_gen_texture(config.seed, config.octaves, config.period, config.persistence)]
	return noise_list

func get_noise_render_new_static(gen_pos = Vector2(0, 0), gen_size = Vector2(10, 10), noise_set_info = []): # it can LAGGGG
	var noise_texture = get_gen_texture(noise_set_info.seed, noise_set_info.octaves, noise_set_info.period, noise_set_info.persistence)
	var noise_info = []
	var tick_x = 0
	var tick_y = 0
	while(tick_x != gen_size.x):
		while(tick_y != gen_size.y):
			noise_info += [noise_texture.get_noise_2d(gen_pos.x+tick_x, gen_pos.y+tick_y)]
			tick_y += 1
		tick_x += 1
	return noise_info

var _dynamic_IN_USE = false

var _dynamic_noise_si = []
var _dynamic_gen_pos = Vector2(0, 0)
var _dynamic_gen_size = Vector2(10, 10)

func prepare_noise_render_new_dynamic(gen_pos = Vector2(0, 0), gen_size = Vector2(10, 10), noise_set_info = []):
	if not(_dynamic_IN_USE):
		_dynamic_noise_si = noise_set_info
		_dynamic_gen_pos = gen_pos
		_dynamic_gen_size = gen_size
		_dynamic_stage = 0
		_dynamic_IN_USE = true
		return true
	else:
		return false

var noises_to_render = []

func prepare_multiple_render_new_dynamic(array = []):
	noises_to_render += array

func _multiple_render_process():
	if(noises_to_render.size() > 0):
		if(prepare_noise_render_new_dynamic(noises_to_render[0].pos, noises_to_render[0].size, noises_to_render[0].info)):
			noises_to_render.remove(0)

var _dynamic_stage = 0

var _dynamic_DELTA_noise = OpenSimplexNoise.new()
var _dynamic_DELTA_render_pos = Vector2(0, 0)

var _dynamic_END_list = []

var last_render_result = []

func _render_noise_process():
	if(_dynamic_IN_USE):
		if(_dynamic_stage == 0):
			_dynamic_DELTA_noise = get_gen_texture(_dynamic_noise_si.seed, _dynamic_noise_si.octaves, _dynamic_noise_si.period, _dynamic_noise_si.persistance)
			_dynamic_stage = 1
		elif(_dynamic_stage == 1):
			_dynamic_END_list += [_dynamic_DELTA_noise.get_noise_2d(_dynamic_gen_pos.x+_dynamic_DELTA_render_pos.x, _dynamic_gen_pos.y+_dynamic_DELTA_render_pos.y)]
			_on_render_update(_dynamic_gen_pos.x+_dynamic_DELTA_render_pos.x, _dynamic_gen_pos.y+_dynamic_DELTA_render_pos.y, _dynamic_END_list[_dynamic_END_list.size()-1])
			_dynamic_DELTA_render_pos.x += 1
			if(_dynamic_DELTA_render_pos.x >= _dynamic_gen_size.x):
				_dynamic_DELTA_render_pos.x = 0
				_dynamic_DELTA_render_pos.y += 1
			if(_dynamic_DELTA_render_pos.y >= _dynamic_gen_size.y):
				_dynamic_DELTA_render_pos = 0
				_dynamic_stage = 0
				_dynamic_IN_USE = false
				last_render_result = _dynamic_DELTA_noise

var output_list = []

func _on_render_update(x, y, output):
	for node in output_list:
		get_tree().get_root().get_node(node)._on_render_update(x, y, output)

func __REG_output_render(node_path):
	output_list += [node_path]

func __UNREG_output_render(node_path):
	if(output_list.has(node_path)):
		output_list.remove(output_list.find(node_path))

