extends Card

func _init() -> void:
	cost = 
	priority = 
	alignment = ALIGNMENT.Default
	role = "Basic"
	description = "Apply Fatigue 1 to opponent. If they're Fatigued, apply Fatigue 3 instead."
	name = "Cripple"
	tags = ['Utility']
	rarity = RARITY.Rare

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
