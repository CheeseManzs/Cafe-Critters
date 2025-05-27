extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Basic"
	description = "Gain Regen 3. Gain 1 MP."
	name = "Prime"
	tags = ['Utility', ' Self-Target']
	rarity = RARITY.Rare

func effect(attacker: BattleMonster, defender: BattleMonster):
	await giveStatus(attacker, Status.EFFECTS.REGEN, 3)
	await attacker.addMP(1)
