extends Card

func _init() -> void:
	cost = 5
	priority = 0
	alignment = ALIGNMENT.Anvi
	role = "Ignetor"
	description = "Attack 200%. If the opponent Fae has 30% HP or less, Execute them."
	name = "Blood in the Tremors"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass
