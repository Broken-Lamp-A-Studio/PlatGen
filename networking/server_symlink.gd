extends Node


func _stop_lobby_listening():
	if(get_tree().get_root().get_node_or_null("init/envoirment/server")):
		if(get_tree().get_root().get_node_or_null("init/envoirment/server")._lobby.is_listening()):
			get_tree().get_root().get_node_or_null("init/envoirment/server")._lobby.stop()

func _stop_server_listening():
	if(get_tree().get_root().get_node_or_null("init/envoirment/server")):
		_stop_lobby_listening()
		if(get_tree().get_root().get_node_or_null("init/envoirment/server").websocket.is_listening()):
			get_tree().get_root().get_node_or_null("init/envoirment/server").websocket.stop()

#func _save_server_world():
#	if(get_tree().get_root().get_node_or_null("init/envoirment/server")):
#
