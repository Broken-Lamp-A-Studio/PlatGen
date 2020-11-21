extends Node2D


func viewport_info(data):
	get_node("player/GUI/Info/player-info").text = data

func _process(delta):
	viewport_info("%d"%get_node("player").position.x+"\n%d"%get_node("player").position.y+"\n%d"%get_node("world").VM_m_x+"\n%d"%get_node("world").VM_m_y)
