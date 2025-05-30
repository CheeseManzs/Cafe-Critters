extends Card

func _init() -> void:
	cost = 4
	priority = 1
	alignment = ALIGNMENT.Default
	role = "Slocha"
	description = "Gain (160% DEF) block. Apply Fatigue 1 to opponent. If this card is played with a modified cost, opposing fae discards 2 and draws that many."
	name = "Affogato"
	tags = ['Defence']
	rarity = RARITY.Uncommon

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
