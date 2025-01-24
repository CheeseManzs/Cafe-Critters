extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Default
	role = ROLE.Generic
	description = "75% Attack. If Tagged, 150% Attack instead."
	name = "Last Chance"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	#calc attack power
	var dmg = attacker.attack*0.75
	if attacker.hasStatus(Status.EFFECTS.TAGGED):
		dmg = attacker.attack*1.50
	#self damage
	defender.receiveDamage(dmg,attacker)
	
	return dmg

#checks what status will be removed from the user
func calcDamage(attacker: BattleMonster, defender: BattleMonster) -> int:
	var dmg = attacker.attack*0.75
	if attacker.hasStatus(Status.EFFECTS.TAGGED):
		dmg = attacker.attack*1.50
	return dmg
