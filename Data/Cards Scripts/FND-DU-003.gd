extends Card

func _init() -> void:
	cost = 2
	priority = 1
	alignment = ALIGNMENT.Default
	role = "Slocha"
	description = "Gain (60% DEF) block. If this card is played with a modified cost, apply Fatigue 2 to opponent."
	name = "Latte"
	tags = ['Defence', ' Self-Target']
	rarity = RARITY.Uncommon

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
