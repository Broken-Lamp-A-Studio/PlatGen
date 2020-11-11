extends Node2D


func viewport_info(data):
	var px = get_node("player").position.x
	var py = get_node("player").position.y
	get_node("GUI/Info/player-info").rect_position.x = px-200
	get_node("GUI/Info/player-info").rect_position.y = py-200
	get_node("GUI/Info/player-info").text = data
	get_node("GUI/Info/version").rect_position.x = px-200+get_viewport_rect().size.x/2
	get_node("GUI/Info/version").rect_position.y = py-25+get_viewport_rect().size.y/2

func _process(delta):
	viewport_info("%d"%get_node("player").position.x+"\n%d"%get_node("player").position.y)
