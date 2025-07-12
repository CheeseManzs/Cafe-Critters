extends Card

func _init() -> void:
	cost = 3
	priority = 1
	alignment = ALIGNMENT.Kress
	role = "Basic"
	description = "Gain (100% DEF) block. Gain Focus 3. Next round start: Draw 1."
	name = "Harmonize"
	tags = ['Defence', 'Self-Target']
	rarity = RARITY.Rare

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
