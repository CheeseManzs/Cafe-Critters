extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Kress
	role = "Basic"
	description = "Deal (10% ATK) unblockable damage. If you played 5+ skills last turn, deal (15% ATK) more unblockable damage."
	name = "Sonic Boom"
	tags = ['Attack']
	rarity = RARITY.Common
	power = 0.1

func effect(attacker: BattleMonster, defender: BattleMonster):
	var extraPower = 0
	if len(attacker.playedCardCurrentTurnHistory) >= 5:
		extraPower = 0.15
	var dmg = _calcPower(attacker,defender, power + extraPower, false)
	await defender.trueDamage(dmg, attacker)
