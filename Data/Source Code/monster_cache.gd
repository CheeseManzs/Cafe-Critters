class_name MonsterCache
extends Resource

@export var cache: Array[Monster]
@export var cardCache: Array[Card]
@export var passiveCache: Array[PassiveAbility]
@export var cardFolderPath: String
@export var cardScriptsPath: String

var loadedCards = false

#monArr is a dictionary where the key is the monster and the value is its corrosponding deck
func toCacheArray(monArr: Dictionary[Monster, Array]) -> Array[Array]:
	var cacheArr: Array[Array] = []
	for mon in monArr.keys():
		print("mon name: ", mon.name)
		var monID = mon.id
		var monCards = monArr[mon]
		var idArr = getCardIDs(monCards)
		var packedArr = [mon.id, idArr, mon.level, mon.heldItem]
		cacheArr.push_back(packedArr)
	return cacheArr
	
func toBinary(u: int, bits: int) -> String:
	var subBitString = ""
	for i in bits:
		var remainder = u%2
		u = int(u/2)
		subBitString += str(remainder)
	subBitString = subBitString.reverse()
	return subBitString

func toDec(b: String) -> int:
	var u: int = 0
	var scaler = 1
	var leastSigOrder = b.reverse()
	for bit in leastSigOrder:
		u += scaler*int(bit)
		scaler *= 2
	return u

static func countDuplicates(arr: Array) -> Dictionary:
	var dict = {}
	for element in arr:
		if !dict.has(element):
			dict[element] = 1
		else:
			dict[element] = dict[element] + 1
	return dict
	
static func countCardDuplicates(arr: Array[Card]) -> Dictionary:
	var dict = {}
	for element in arr:
		if !dict.has(element.name):
			dict[element.name] = 1
		else:
			dict[element.name] = dict[element.name] + 1
	return dict
	
func encode(cacheArr: Array[Array]) -> String:
	var monsterArray = toMonsterArray(cacheArr)
	var decodeFormat = "{name} ({level}){item}{cards}"
	var cardFormat = "\n- {cardname} ({cardcount})"
	var pasteString = "```"
	for mon in monsterArray:
		var name = mon.name
		print("mon name to export: ", name)
		var level = mon.level
		var cards = ""
		var item = ""
		if !mon.getHeldItem().isNone():
			item = " + " + mon.getHeldItem().toString()
		var cardArr = []
		for card in mon.deck.storedCards:
			cardArr.append(card.name)
		var duplicates = countDuplicates(cardArr)
		for card in duplicates.keys():
			cards += cardFormat.format({"cardname":card,"cardcount":duplicates[card]})
		
		var obj = {"name":name,"level":level,"item":item,"cards":cards}
		var monString = decodeFormat.format(obj)
		print(monString)
		pasteString = pasteString + "\n"+monString
		
	pasteString += "\n```"
	print(pasteString)
	return pasteString
		

func decode(decoding: String) -> Array[Monster]:
	if len(decoding) == 0:
		return []
	
	loadCards()
	
	var cardDict = {}
	var lines = decoding.split("\n")
	var team: Array[Monster] = []
	var currentMon: Monster = null
	for line in lines:
		if line == "```":
			continue
		if line.begins_with("-"):
			var cardData: Array[String] 
			cardData.assign(line.split(" ("))
			cardData[0] = cardData[0].replace("- ", "")
			cardData[1] = cardData[1].replace(")","")
			var cardName = cardData[0]
			var cardCount = int(cardData[1])
			var card = getCard(getCardIDByName(cardName))
			if currentMon == null:
				return []
			for i in cardCount:
				currentMon.deck.storedCards.push_back(card.duplicate())
		else:
			var monData: Array[String]
			monData.assign(line.split(" ("))
			monData[1] = monData[1].replace(")","")
			if " + " in monData[1]:
				var itemData = monData[1].split(" + ")
				monData = [monData[0], itemData[0], itemData[1]]
			var monName = monData[0]
			print("mon data: ",monData[1])
			var monLevel = int(monData[1])
			
			currentMon = getMonsterByName(monName)
			currentMon.level = monLevel
			currentMon.heldItem = HeldItem.new()
			
			if len(monData) > 2:
				var monItem = HeldItem.fromString(monData[2], self)
				currentMon.heldItem = monItem
			
			currentMon.deck.storedCards = []
				
			team.push_back(currentMon)
	
	return team
		
	
func toMonsterArray(cacheArr: Array[Array]) -> Array[Monster]:
	var monArr: Array[Monster] = []
	for packed in cacheArr:
		var monDeck: Array[int]
		monDeck.assign(packed[1])
		var mon = getMonster(packed[0])
		mon.deck.storedCards = getCards(monDeck)
		mon.level = packed[2]
		mon.heldItem = packed[3]
		monArr.push_back(mon)
	return monArr
	
func toMonsterDict(cacheArr: Array[Array]) -> Dictionary[Monster, Array]:
	var monArr: Dictionary[Monster, Array] = {}
	for packed in cacheArr:
		var mon = getMonster(packed[0])
		mon.level = packed[2]
		var moncards = getCards(packed[1])
		monArr[mon] = moncards
	return monArr


func getMonster(id: int) -> Monster:
	#i know i can just use the index but this is probably easier and safer
	for monster in cache:
		if monster.id == id:
			return monster.duplicate(true)
	return null

func getMonsterByName(name: String) -> Monster:
	for monster in cache:
		if monster.name == name:
			return monster.duplicate(true)
	return null

func getCard(id: int) -> Card:
	return cardCache[id].clone()
	
func getCards(ids: Array[int]) -> Array[Card]:
	var cards: Array[Card] = []
	for id in ids:
		cards.push_back(getCard(id))
	return cards
	
func loadCards():
	if loadedCards:
		return
	
	loadedCards = true
	
	if !cardFolderPath.ends_with("/"):
		cardFolderPath = cardFolderPath + "/"
	
	cardCache = []
	if !DirAccess.dir_exists_absolute(cardFolderPath):
		print(cardFolderPath, " does not exist!")
		return
	var dir = DirAccess.open(cardFolderPath)
	dir.list_dir_begin()
	var filename = dir.get_next()
	while filename != "":
		print("loading ",filename)
		var absPath = cardFolderPath+filename
		var card = ResourceLoader.load(absPath, "Card")
		print(filename, " > ", card.name)
		print(filename, " is null: ", (card == null))
		cardCache.push_back(card)
		filename = dir.get_next()
	loadScripts()

func loadScripts():
	if !cardScriptsPath.ends_with("/"):
		cardScriptsPath = cardScriptsPath + "/"
	
	cardCache = []
	if !DirAccess.dir_exists_absolute(cardScriptsPath):
		print(cardScriptsPath, " does not exist!")
		return
	var dir = DirAccess.open(cardScriptsPath)
	dir.list_dir_begin()
	var filename = dir.get_next()
	while filename != "":
		print("checking ",filename)
		var valid = filename.ends_with(".gd") && filename.contains("FND-")
		if valid:
			print("loading ",filename)
			var absPath = cardScriptsPath+filename
			var card = Card.new()
			card.set_script(load(absPath))
			card._init()
			print(filename, " > ", card.name)
			print(filename, " is null: ", (card == null))
			var dupe = false
			for _card in cardCache:
				if _card.name == card.name:
					dupe = true
					break
			if !dupe:
				cardCache.push_back(card)
		filename = dir.get_next()

func getCardID(card: Card) -> int:
	for id in len(cardCache):
		var matching = cardCache[id]
		if matching.get_script().get_path() == card.get_script().get_path():
			return id
	return -1
	
func getCardIDByName(cardName: String) -> int:
	for id in len(cardCache):
		var matching = cardCache[id]
		if matching.name == cardName:
			return id
	return -1
	
func getCardByName(cardName: String) -> Card:
	for id in len(cardCache):
		var matching = cardCache[id]
		if matching.name == cardName:
			return matching
	return null

func getCardIDs(cards: Array[Card]) -> Array[int]:
	if len(cardCache) == 0:
		loadCards()
		
	var arr: Array[int] = []
	for card in cards:
		var id = getCardID(card)
		arr.push_back(id)
	return arr
	
func getCardIDsByName(cards: Array[String]) -> Array[int]:
	if len(cardCache) == 0:
		loadCards()
		
	var arr: Array[int] = []
	for card in cards:
		var id = getCardIDByName(card)
		arr.push_back(id)
	return arr

func getPassiveByName(passiveName: String) -> PassiveAbility:
	for passive in passiveCache:
		if passive.name == passiveName:
			return passive
	return passiveCache[0]

static func defaultMonsterDict(mons: Array[Monster]) -> Dictionary[Monster, Array]:
	var debTeam: Dictionary[Monster, Array] = {}
	for mon in mons:
		debTeam[mon] = mon.deck.storedCards
	return debTeam
