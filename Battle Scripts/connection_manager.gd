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
@export_multiline var defaultTeam: String

var targetIP = "debug"
static var hasSetTeam: bool = false
static var playerTeam: Array[Monster]

var peer = ENetMultiplayerPeer.new()
var upnp = UPNP.new()

const PORT = 9999
const ADDRESS = "localhost"

static var singleton: ConnectionManager = null
static var host = false

func _ready() -> void:
	if singleton == null:
		singleton = self
	if hasSetTeam == false || len(playerTeam) == 0:
		hasSetTeam = true
		playerTeam = teamPacker.decode(defaultTeam)
	
	var debTeam: Dictionary[Monster, Array] = {}
	for mon in playerTeam:
		debTeam[mon] = mon.deck.storedCards
	
	teamText.text = teamPacker.encode(teamPacker.toCacheArray(debTeam))
	setTeam()


static func setTeamManual(monArr: Array[Monster]):
	playerTeam = []
	for mon in monArr:
		if mon != null:
			playerTeam.push_back(mon)

func setTeam():
	var currentTeam: String
	playerTeam = teamPacker.decode(teamText.text)
	print("valid: ",DeckVerification.teamIsValid(playerTeam))

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
	await peer.peer_connected
	BattleController.startBattle(playerTeam, playerTeam, ConnectionManager.singleton.defaultPersonality, multiplayer.get_peers().get(0))
	
func joinProcess(inDebug: bool):
	Thread.new().start(upnpSetup.bind())
	await foundUPNP
	var external_ip = upnp.query_external_address()
	if inDebug:
		print("ip: ",external_ip)
	joinServer(inDebug)
	await peer.peer_connected
	BattleController.startBattle(playerTeam, playerTeam, ConnectionManager.singleton.defaultPersonality, multiplayer.get_peers().get(0)) #host id is always 0

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
