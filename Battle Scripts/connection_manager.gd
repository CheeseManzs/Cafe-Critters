class_name ConnectionManager
extends Node

signal foundUPNP

@export var ipDisplay: Button
@export var ipText: TextEdit
@export var teamText: TextEdit
@export var teamPacker: MonsterCache
@export var debugManager: DebugGameManager
@export var lockedButtons: Array[Button]
@export var defaultPersonality: AIPersonality

var targetIP = "debug"
var playerTeam: Array[Monster]

var peer = ENetMultiplayerPeer.new()
var upnp = UPNP.new()

const PORT = 9999
const ADDRESS = "localhost"

static var singleton: ConnectionManager = null
static var host = false

func _ready() -> void:
	if singleton == null:
		singleton = self
	
	var debTeam: Dictionary[Monster, Array] = {}
	for mon in debugManager.debugTeamA:
		debTeam[mon] = mon.deck.storedCards
	
	teamText.text = JSON.stringify(teamPacker.toCacheArray(debTeam))
	

func setTeam():
	var currentTeam: Array[Array]
	currentTeam.assign(JSON.parse_string(teamText.text))
	playerTeam = teamPacker.toMonsterArray(currentTeam)

func setIPText(txt):
	ipText.text = txt

func upnpSetup():
		#upnp.delete_port_mapping(9999, "UDP")
	#upnp.delete_port_mapping(9999, "TCP")
	upnp = UPNP.new()
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
			print("calling!")
			foundUPNP.emit.call_deferred()

func eg():
	var createdTeam = [] #<--- THE TEAM YOUR TEAMBUILDER GENERATERS
	ConnectionManager.singleton.targetIP = "ip address" #ONLY FOR JOINING PLAYERS
	ConnectionManager.singleton.playerTeam = createdTeam
	ConnectionManager.singleton.hostProcess(false) #ConnectionManager.singleton.joinProcess(false) for joining player 

func hostServer(inDebug: bool):
	BattleController.multiplayer_game = true
	var external_ip = upnp.query_external_address()
	if inDebug:
		ipDisplay.text = "Hosted on " + str(external_ip)
	
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	host = true
	print("hosted!")

func joinServer(inDebug: bool):
	BattleController.multiplayer_game = true
	if inDebug:
		if ipText.text == "Not Connected":
			ipText.text = "127.0.0.1"
		targetIP = ipText.text
	peer.create_client(targetIP, PORT)
	multiplayer.multiplayer_peer = peer
	host = false
	print("joined!")
	
func hostProcess(inDebug: bool):
	Thread.new().start(upnpSetup.bind())
	await foundUPNP
	var external_ip = upnp.query_external_address()
	if inDebug:
		print("ip: ",external_ip)
		ipText.text = str(external_ip)
	hostServer(inDebug)
	BattleController.startBattle(playerTeam, playerTeam, ConnectionManager.singleton.defaultPersonality)
	
func joinProcess(inDebug: bool):
	Thread.new().start(upnpSetup.bind())
	await foundUPNP
	var external_ip = upnp.query_external_address()
	if inDebug:
		print("ip: ",external_ip)
	joinServer(inDebug)
	BattleController.startBattle(playerTeam, playerTeam, ConnectionManager.singleton.defaultPersonality)

func _on_online_battle_host_pressed() -> void:
	setTeam()
	for button in lockedButtons:
		button.disabled = true
	ipText.text = "Connecting..."
	hostProcess(true)
	


func _on_online_battle_join_pressed() -> void:
	setTeam()
	for button in lockedButtons:
		button.disabled = true
	joinProcess(true)
