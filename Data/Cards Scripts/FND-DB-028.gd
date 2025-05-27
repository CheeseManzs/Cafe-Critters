extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Basic"
	description = "Apply Fatigue 1 to opponent."
	name = "Hinder"
	tags = ['Utility']
	rarity = RARITY.Rare

func effect(attacker: BattleMonster, defender: BattleMonster):
	await giveStatus(defender, Status.EFFECTS.FATIGUE, 1)
