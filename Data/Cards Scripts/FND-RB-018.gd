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

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
