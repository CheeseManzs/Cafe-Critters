extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Default
	role = ROLE.Generic
	description = "Gain 1 mp. 20% Attack."
	name = "Last Chance"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	#add mp
	attacker.addMP(1)
	#calc attack power
	var dmg = attacker.attack*0.2
	#self damage
	defender.receiveDamage(dmg,attacker)
	
	return dmg

#checks what status will be removed from the user
func calcDamage(attacker: BattleMonster, defender: BattleMonster) -> int:
	return attacker.attack*0.2
