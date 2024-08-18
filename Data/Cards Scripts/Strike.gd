extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Default
	role = ROLE.Generic
	description = "100% Attack."
	name = "Strike"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	var dmg = attacker.attack
	if statusConditions.has(Status.EFFECTS.EMPOWER):
		dmg = ceil(dmg*1.5)
	var trueDmg = defender.receiveDamage(dmg, attacker)
	return trueDmg

func calcDamage(attacker: BattleMonster, defender: BattleMonster) -> int:
	var dmg = attacker.attack
	if statusConditions.has(Status.EFFECTS.EMPOWER):
		dmg = ceil(dmg*1.5)
	return dmg
