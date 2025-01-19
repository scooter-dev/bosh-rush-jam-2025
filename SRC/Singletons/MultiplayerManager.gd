extends Node

var player : Array[Player]

func _ready() -> void:
	multiplayer.connected_to_server
	multiplayer.connection_failed
	multiplayer.peer_connected
	multiplayer.peer_disconnected

func hostGame(port : int, max_players : int) -> void:
	var peer : ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	peer.create_server(port, max_players)
	get_tree().get_multiplayer().multiplayer_peer = peer

func joinGame(ip : String, port : int) -> void:
	var peer : ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	peer.create_client(ip, port)
	get_tree().get_multiplayer().multiplayer_peer = peer

func onPlayerJoined(id : int) -> void:
	pass

func onPlayerLeft(id : int) -> void:
	pass

func onConnectionFailed() -> void:
	pass

func onConnectionSuccess() -> void:
	pass
