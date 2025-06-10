extends Card

func _init() -> void:
	cost = 3
	priority = 1
	alignment = ALIGNMENT.Rea
	role = "Basic"
	description = "If the opponent will Attack this action, gain (100% DEF) block and 1 MP."
	name = "Due Diligence"
	tags = ['Defence', 'Self-Target']
	rarity = RARITY.Uncommon
	shieldPower = 1

func effect(attacker: BattleMonster, defender: BattleMonster):
	var sequence: BattleSequence = attacker.battleController.currentBattleSequence
	var willAttack = false
	if sequence != null:
		for action in sequence.actions:
			if action.battleMonster == defender && "Attack" in action.card.tags:
				willAttack = true
				break
	if willAttack:
		await giveShield(attacker,defender)
		await attacker.addMP(1)
