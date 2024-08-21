extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Default
	role = ROLE.Unique
	description = "Set your Attack to 0. Empower the next card played."
	name = "Press"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	attacker.setAttack(0)
	attacker.addStatusCondition(Status.new(Status.EFFECTS.EMPOWER_PLAYED))
	return 0

func calcBonus(attacker: BattleMonster, defender: BattleMonster) -> int:
	return 1
