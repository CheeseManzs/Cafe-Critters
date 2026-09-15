extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Anvi
	description = "Forge 1."
	name = "Forge"
	tags = ['Utility']
	rarity = RARITY.Common

func effect(attacker: BattleMonster, defender: BattleMonster):
	await attacker.chooseAndForgeCard(3)
	pass
	
