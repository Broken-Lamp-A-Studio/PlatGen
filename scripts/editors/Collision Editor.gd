extends Control


onready var symlink = get_node("/root/MainSymlink")

var symlink2 = false
var path = ""

func _process(_delta):
	if(symlink2 != symlink.collision_editor):
		if(symlink.collision_editor):
			$collisionlist.popup_centered_minsize()
		else:
			$collisionlist.hide()
			$editcollision.hide()
		symlink2 = symlink.collision_editor

var shape_selected = 0

func _on_nc_pressed():
	$newcollision.popup_centered_minsize()


func _on_create_pressed():
	if($newcollision/name/LineEdit.text != ""):
		var json = {}
		if(shape_selected == 0):
			json = {"name":$newcollision/name/LineEdit.text, "size":{"x":10, "y":10}, "type":"rectangle"}
		elif(shape_selected == 1):
			json = {"name":$newcollision/name/LineEdit.text, "size":{"r":5}, "type":"circle"}
		elif(shape_selected == 2):
			json = {"name":$newcollision/name/LineEdit.text, "size":{"1":{"x":10, "y":10}, "2":{"x":20, "y":20}}, "type":"line"}
		$collisionlist/collisions.add_item($newcollision/name/LineEdit.text, $newcollision/type/ItemList.get_item_icon(shape_selected))
		$collisionlist/collisions.set_item_metadata($collisionlist/collisions.get_item_count()-1, json)
		$newcollision.hide()
		$newcollision/name/LineEdit.text = ""


func _on_ItemList_item_selected(index):
	shape_selected = index

var selected = -1

func _on_rc_pressed():
	#print($collisionlist/collisions.items)
	if not(selected == -1):
		print($collisionlist/collisions.get_item_metadata(selected))
		$collisionlist/collisions.remove_item(selected)
		selected = -1


func _on_collisions_item_selected(index):
	selected = index

