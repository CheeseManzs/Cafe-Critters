extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Kress
	role = "Basic"
	description = "Inflict Attack Down 1 and Defense Down 1. If you played 3+ skills last round, this skill goes first."
	name = "Screech"
	tags = ['Utility']
	rarity = RARITY.Common

func earlyEffect(attacker: BattleMonster, defender: BattleMonster):
	if len(attacker.playedCardLastTurnHistory) >= 3:
		priority = 1
	else:
		priority = 0

func effect(attacker: BattleMonster, defender: BattleMonster):
	await giveStatus(defender, Status.EFFECTS.ATTACK_DOWN, 1)
	await giveStatus(defender, Status.EFFECTS.DEFENSE_DOWN, 1)
