extends Control


onready var symlink = get_node("/root/MainSymlink")

var symlink2 = false
var path = ""

func _process(_delta):
	if(symlink2 != symlink.particle_editor):
		if(symlink.particle_editor):
			$collisionlist.popup_centered_minsize()
		else:
			$collisionlist.hide()
			$editcollision.hide()
		symlink2 = symlink.particle_editor


