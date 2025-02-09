extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Forward"
	description = 'When Endless Blows is played, shuffle 3 "Endless Blows" into your deck. (50% + 10% per Endless Blows played) Attack'
	name = "Endless Blows"

func effect(attacker: BattleMonster, defender: BattleMonster):
	for i in range(3):
		var newCard = self.clone()
		attacker.currentDeck.storedCards.push_back(newCard)
	var endlessBlows = 0
	if attacker.hasStatus(Status.EFFECTS.ENDLESS_BLOWS):
		endlessBlows = attacker.getStatus(Status.EFFECTS.ENDLESS_BLOWS).X
	for blow in range(endlessBlows):
		await dealDamage(attacker, defender, 0.1)
		await attacker.battleController.get_tree().create_timer(0.5).timeout
	power = 0.5# + 0.1*endlessBlows
	await dealDamage(attacker, defender)
	await giveStatus(attacker,Status.EFFECTS.ENDLESS_BLOWS,1,0,false)
	return

func calcDamage(attacker: BattleMonster, defender: BattleMonster) -> int:
	var endlessBlows = 0
	if attacker.hasStatus(Status.EFFECTS.ENDLESS_BLOWS):
		endlessBlows = attacker.getStatus(Status.EFFECTS.ENDLESS_BLOWS).X
	return _calcPower(attacker, defender, 0.5 + 0.1*endlessBlows)
