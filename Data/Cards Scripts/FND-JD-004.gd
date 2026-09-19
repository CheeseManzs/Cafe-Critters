extends Card

func _init() -> void:
	cost = 3
	priority = 0
	alignment = ALIGNMENT.Jacks
	description = "Fold: Gain 1 AP"
	name = "Hero Fold"
	tags = ['Utility']
	rarity = RARITY.Uncommon

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass

func onDiscarded(attacker: BattleMonster):
	attacker.addMP(1)
	pass
	
