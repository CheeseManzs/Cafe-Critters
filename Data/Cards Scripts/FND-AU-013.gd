extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Anvi
	role = "Junkguard"
	description = "Shuffle 10 "Block" cards into your deck. They are token cards in addition to their other types."
	name = "Command: Build Shields"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass
