extends Node


func _client_stop():
	if(get_tree().get_root().get_node_or_null("init/envoirment/client")):
		get_tree().get_root().get_node_or_null("init/envoirment/client")._client.disconnect_from_host(-1, "Exit...")
	if(get_tree().get_root().get_node_or_null("init/envoirment/game_client")):
		get_tree().get_root().get_node_or_null("init/envoirment/game_client")._client.disconnect_from_host(-1, "Exit...")
	
