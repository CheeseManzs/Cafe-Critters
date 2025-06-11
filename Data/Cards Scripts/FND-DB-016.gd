extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Basic"
	description = "Shuffle 3 Endless Blows into your deck. Deal (50% ATK) damage, plus (10% ATK) for each Endless Blows played this game"
	name = "Endless Blows"
	tags = ['Attack']
	rarity = RARITY.Epic
	power = 0.5

func effect(attacker: BattleMonster, defender: BattleMonster):
	if attacker.hasStatus(Status.EFFECTS.ENDLESS_BLOWS):
		for i in attacker.getStatus(Status.EFFECTS.ENDLESS_BLOWS).X:
			await dealDamage(attacker, defender, 0.1)
	await dealDamage(attacker, defender)
	await giveStatus(attacker, Status.EFFECTS.ENDLESS_BLOWS, 1,0,CardFilter.new(),false,false)
	#add 3 endless blows
	for i in 3:
		var newCard = attacker.battleController.monsterCache.getCardByName("Endless Blows").duplicate()
		attacker.currentDeck.storedCards.push_back(newCard)
	pass

func calcDamage(attacker: BattleMonster, defender: BattleMonster) -> int:
	var blows = 0
	if attacker.hasStatus(Status.EFFECTS.ENDLESS_BLOWS):
		blows = attacker.getStatus(Status.EFFECTS.ENDLESS_BLOWS).X
	return _calcPower(attacker, defender, 0.5 + 0.1*blows)
