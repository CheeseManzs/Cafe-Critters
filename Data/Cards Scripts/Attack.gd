
extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Default
	role = ROLE.Generic
	description = "Attack using 100% of your Attack stat"
	name = "Attack"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	var dmg = attacker.attack
	var trueDmg = defender.receiveDamage(dmg, attacker)
	return trueDmg
