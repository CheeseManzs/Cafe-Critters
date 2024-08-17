extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Default
	role = ROLE.Support
	description = "Gain 1 mp. Gain Barrier 5."
	name = "Assist"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	#gives 5 shield
	var shieldGiven = 5
	var mpGiven = 1
	#return add shield to user
	attacker.addShield(shieldGiven)
	#add mp
	attacker.addMP(mpGiven)
	return shieldGiven
