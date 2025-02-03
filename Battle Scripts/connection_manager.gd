class_name ConnectionManager
extends Node

signal foundUPNP

@export var ipDisplay: Button
@export var ipText: TextEdit

var peer = ENetMultiplayerPeer.new()
var upnp = UPNP.new()

const PORT = 9999
const ADDRESS = "localhost"

static var singleton: ConnectionManager = null
static var host = false

func _ready() -> void:
	if singleton == null:
		singleton = self
	Thread.new().start(upnpSetup.bind())
	await foundUPNP
	var external_ip = upnp.query_external_address()
	print("ip: ",external_ip)
	ipText.text = str(external_ip)


func upnpSetup():
		#upnp.delete_port_mapping(9999, "UDP")
	#upnp.delete_port_mapping(9999, "TCP")
	var disc_res = upnp.discover()
	if disc_res == UPNP.UPNP_RESULT_SUCCESS:
		print(upnp.get_gateway() and upnp.get_gateway().is_valid_gateway())
		if upnp.get_gateway() and upnp.get_gateway().is_valid_gateway():
			var map_udp = upnp.add_port_mapping(9999,9999,"godot_udp","UDP",0)
			var map_tcp = upnp.add_port_mapping(9999,9999,"godot_tcp","TCP",0)
			print("results: ", map_udp, ", ", map_tcp, " of ", UPNP.UPNP_RESULT_SUCCESS)
			if not map_udp == UPNP.UPNP_RESULT_SUCCESS:
				map_udp = upnp.add_port_mapping(9999,9999,"","UDP")
				print.call_deferred.bind("new mapping: ",map_udp)
			if not map_tcp == UPNP.UPNP_RESULT_SUCCESS:
				map_tcp = upnp.add_port_mapping(9999,9999,"","TCP")
				print.call_deferred.bind("new mapping: ",map_tcp)
			foundUPNP.emit.call_deferred()

func hostServer():
	BattleController.multiplayer_game = true
	
	
	
	var external_ip = upnp.query_external_address()
	
	ipDisplay.text = "Hosted on " + str(external_ip)
	
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	host = true
	print("hosted!")

func joinServer():
	BattleController.multiplayer_game = true
	peer.create_client(ipText.text, PORT)
	multiplayer.multiplayer_peer = peer
	host = false
	print("joined!")
	


func _on_online_battle_host_pressed() -> void:
	hostServer()


func _on_online_battle_join_pressed() -> void:
	joinServer()
