extends Node2D

var r = 100
var g = 100
var b = 255
var up_panel = {"x":0, "y":0}
var block_config = ""
onready var symlink = get_node("/root/MainSymlink")

func _ready():
	block_config = {"name":$gui/UpPanel/name.text, "game_version":"0.57", "elements":$gui/DownPanel.elements, "objects":[], "settings":{}}

func background_process():
	$background.modulate = $gui/background_settings/WindowDialog/Panel/ColorPicker.color
	$background.rect_size.x = get_viewport_rect().size.x+50
	$background.rect_size.y = get_viewport_rect().size.y+50
func gui_viewport_sync():
	$gui.rect_size.x = get_viewport_rect().size.x
	$gui.rect_size.y = get_viewport_rect().size.y
func obj_viewport_sync():
	$Object.position.x = get_viewport_rect().size.x/2
	$Object.position.y = get_viewport_rect().size.y/2
func panel_pos_global_sync():
	up_panel.x = get_viewport_rect().size.x
	up_panel.y = get_viewport_rect().size.y-get_viewport_rect().size.y/1.1
	$gui/UpPanel.rect_size.x = up_panel.x
	$gui/UpPanel.rect_size.y = up_panel.y
	$gui/block_options.rect_position.y = get_viewport_rect().size.y/2
	$gui/block_options.rect_position.x = 0#-$gui/block_options.rect_size.x/2
func _process(_delta):
	symlink.texture_editor = $gui/block_options/te.pressed
	background_process()
	gui_viewport_sync()
	obj_viewport_sync()
	panel_pos_global_sync()


func _on_background_settings_pressed():
	$gui/background_settings/WindowDialog.popup()

func _on_texturelist_popup_hide():
	$gui/block_options/te.pressed = false

