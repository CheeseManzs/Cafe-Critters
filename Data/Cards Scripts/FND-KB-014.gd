extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Kress
	role = "Basic"
	description = "Inflict Poison 1. Next round start: create an Earworm in the active fae's hand."
	name = "Earworm"
	tags = ['Utility']
	rarity = RARITY.Uncommon

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
