extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Rea
	role = "Basic"
	description = "Omen. Inflict Fatigue 1 and deal (10% ATK) unblockable damage to all opponent Faes. "
	name = "Baleful Wailing"
	tags = ['Attack', 'Omen']
	rarity = RARITY.Common
	power = 0.1

func effect(attacker: BattleMonster, defender: BattleMonster):
	
	for mon in defender.battleController.getTeam(defender):
		if mon.isKO():
			continue
		var dmg = _calcPower(attacker, defender, power, false)
		await giveStatus(defender, Status.EFFECTS.FATIGUE, 1)
		await mon.trueDamage(dmg, attacker)
	await applyOmen(attacker, defender)
	pass

func calcStatusInflicted(attacker: BattleMonster, defender: BattleMonster) -> Status:
	return Status.new(Status.EFFECTS.FATIGUE, 1)
