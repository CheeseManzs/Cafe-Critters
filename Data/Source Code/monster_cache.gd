class_name MonsterCache
extends Resource

@export var cache: Array[Monster]
@export var cardCache: Array[Card]
@export var cardFolderPath: String

#monArr is a dictionary where the key is the monster and the value is its corrosponding deck
func toCacheArray(monArr: Dictionary[Monster, Array]) -> Array[Array]:
	var cacheArr: Array[Array] = []
	for mon in monArr.keys():
		var monID = mon.id
		var monCards = monArr[mon]
		var idArr = getCardIDs(monCards)
		var packedArr = [mon.id, idArr, mon.level]
		cacheArr.push_back(packedArr)
	return cacheArr
	
func toMonsterArray(cacheArr: Array[Array]) -> Array[Monster]:
	var monArr: Array[Monster] = []
	for packed in cacheArr:
		var monDeck: Array[int]
		monDeck.assign(packed[1])
		var mon = getMonster(packed[0])
		mon.deck.storedCards = getCards(monDeck)
		mon.level = packed[2]
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
	
func getCard(id: int) -> Card:
	return cardCache[id].clone()
	
func getCards(ids: Array[int]) -> Array[Card]:
	var cards: Array[Card] = []
	for id in ids:
		cards.push_back(getCard(id))
	return cards
	
func loadCards():
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
		cardCache.push_back(card)
		filename = dir.get_next()
	

func getCardID(card: Card) -> int:
	for id in len(cardCache):
		var matching = cardCache[id]
		if matching.get_script().get_path() == card.get_script().get_path():
			return id
	return -1

func getCardIDs(cards: Array[Card]) -> Array[int]:
	if len(cardCache) == 0:
		loadCards()
		
	var arr: Array[int] = []
	for card in cards:
		var id = getCardID(card)
		arr.push_back(id)
	return arr

static func defaultMonsterDict(mons: Array[Monster]) -> Dictionary[Monster, Array]:
	var debTeam: Dictionary[Monster, Array] = {}
	for mon in mons:
		debTeam[mon] = mon.deck.storedCards
	return debTeam
