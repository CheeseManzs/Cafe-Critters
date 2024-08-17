extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Default
	role = ROLE.Support
	description = "Gain 1 mp. Gain Barrier 5."
	name = "Assist"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	#idk what barrier is ngl but remember to apply empower to it
	var mpGiven = 1
	#add mp
	attacker.addMP(mpGiven)
	return mpGiven
