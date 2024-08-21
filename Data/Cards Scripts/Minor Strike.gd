extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Default
	role = ROLE.Generic
	description = "50% Attack."
	name = "Minor Strike"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	var dmg = ceil(attacker.getAttack()/2.0)
	if statusConditions.has(Status.EFFECTS.EMPOWER):
		dmg = ceil(dmg*1.5)
	var trueDmg = defender.receiveDamage(dmg, attacker)
	return trueDmg

func calcDamage(attacker: BattleMonster, defender: BattleMonster) -> int:
	var dmg = ceil(attacker.getAttack()/2.0)
	if statusConditions.has(Status.EFFECTS.EMPOWER):
		dmg = ceil(dmg*1.5)
	return dmg
