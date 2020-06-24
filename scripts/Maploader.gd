extends Node2D

var posx = 0
var posy = 0

func _ready():
	set_process(true)



func _process(_delta):
	get_node("StaticBody2D").position.x = self.posx
	get_node("dirt").position.x = self.posx
	get_node("cobble").position.x = self.posx
	get_node("StaticBody2D").position.y = self.posy
	get_node("dirt").position.y = self.posy
	get_node("cobble").position.y = self.posy
