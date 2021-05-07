extends Control


onready var symlink = get_node("/root/MainSymlink")

var symlink2 = false
var path = ""

func _ready():
	$FileDialog.add_filter("*.png ; PNG file")


func _process(_delta):
	$newtexture/path.text = "Path: "+path
	if(symlink2 != symlink.texture_editor):
		if(symlink.texture_editor):
			$texturelist.popup_centered_minsize()
		else:
			$texturelist.hide()
			$newtexture.hide()
			$edittexture.hide()
			$FileDialog.hide()
		symlink2 = symlink.texture_editor
	edit_texture_lines()
	set_controls()

func _on_nt_pressed():
	$newtexture.popup_centered_minsize()

func _on_select_path_pressed():
	$FileDialog.popup_centered_minsize()


func _on_create_pressed():
	if($newtexture/name.text != ""):
		if(path != ""):
			add_texture2($newtexture/name.text, path)
			$newtexture/name.text = ""
			path = ""
			$newtexture.hide()
		else:
			symlink.console_output("Please select path to the texture.", "err")
	else:
		symlink.console_output("Please specify name for the texture.", "err")

func add_texture2(name2, pt):
	var atlas = AtlasTexture.new()
	atlas.atlas = load(pt)
	if not(atlas.atlas.get_size().x >= 200 or atlas.atlas.get_size().y >= 200):
		atlas.set_region(Rect2(0, 0, atlas.atlas.get_size().x, atlas.atlas.get_size().y))
#		atlas.region.x = 0
#		atlas.region.y = 0
#		atlas.region.w = atlas.atlas.get_size().x
#		atlas.region.h = atlas.atlas.get_size().y
		$texturelist/textures.add_item(name2, atlas, false)
	else:
		symlink.console_output("Texture bigger than 200x200 cannot be loaded!", "err")



func _on_FileDialog_file_selected(path2):
	path = path2
	$FileDialog.hide() 

var selected = null

func _on_rt_pressed():
	if(selected != null):
		$texturelist/textures.remove_item(selected)

func _on_textures_item_selected(index):
	selected = index



func _on_et_pressed():
	if(selected != null):
		var at = $texturelist/textures.get_item_icon(selected)
		edit_atlas(at)

var atlas_size = {"position":{"x":0, "y":0}, "size":{"x":0, "y":0}}

func edit_atlas(atlas):
	atlas_size = atlas.get_region()
	$edittexture/TextureRect.texture = atlas.atlas
	$"edittexture/Offset X/slider".tick_count = $edittexture/TextureRect.texture.get_size().x
	$"edittexture/Offset Y/slider".tick_count = $edittexture/TextureRect.texture.get_size().y
	$"edittexture/Offset W/slider".tick_count = $edittexture/TextureRect.texture.get_size().y
	$"edittexture/Offset H/slider".tick_count = $edittexture/TextureRect.texture.get_size().x
	$"edittexture/Offset X/slider".max_value = $edittexture/TextureRect.texture.get_size().x
	$"edittexture/Offset Y/slider".max_value = $edittexture/TextureRect.texture.get_size().y
	$"edittexture/Offset W/slider".max_value = $edittexture/TextureRect.texture.get_size().y
	$"edittexture/Offset H/slider".max_value = $edittexture/TextureRect.texture.get_size().x
	$"edittexture/Offset X/slider".value = atlas_size.position.x
	$"edittexture/Offset Y/slider".value = atlas_size.position.y
	$"edittexture/Offset W/slider".value = atlas_size.size.y
	$"edittexture/Offset H/slider".value = atlas_size.size.x
	$edittexture.popup_centered_minsize()

func set_controls():
	atlas_size.position.x = $"edittexture/Offset X/slider".value
	atlas_size.position.y = $"edittexture/Offset Y/slider".value
	atlas_size.size.y = $"edittexture/Offset W/slider".value
	atlas_size.size.x = $"edittexture/Offset H/slider".value
	

func edit_texture_lines():
	var pos = Vector2($edittexture/TextureRect.rect_position.x+atlas_size.position.x-9, $edittexture/TextureRect.rect_position.y+atlas_size.position.y-9)
	var pos2 = Vector2($edittexture/TextureRect.rect_position.x+atlas_size.position.x-9, $edittexture/TextureRect.rect_position.y+atlas_size.position.y+atlas_size.size.y-9)
	var pos3 = Vector2($edittexture/TextureRect.rect_position.x+atlas_size.position.x-9+atlas_size.size.x, $edittexture/TextureRect.rect_position.y+atlas_size.position.y+atlas_size.size.y-9)
	var pos4 = Vector2($edittexture/TextureRect.rect_position.x+atlas_size.position.x-9+atlas_size.size.x, $edittexture/TextureRect.rect_position.y+atlas_size.position.y-9)
	get_node("edittexture/TextureRect/1").points = [pos, pos2, pos3, pos4, pos]


func _on_edittexture_popup_hide():
	var atlas = AtlasTexture.new()
	atlas.atlas = $edittexture/TextureRect.texture
	atlas.set_region(atlas_size)
	$texturelist/textures.set_item_icon(selected, atlas)
