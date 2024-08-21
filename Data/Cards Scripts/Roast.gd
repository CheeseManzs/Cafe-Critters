extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Default
	role = ROLE.Unique
	description = "Take damage equal to your Attack. Empower the next card played."
	name = "Roast"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	var dmg: int = attacker.getAttack()
	attacker.receiveDamage(dmg, attacker)
	attacker.addStatusCondition(Status.new(Status.EFFECTS.EMPOWER_PLAYED))
	return 0
