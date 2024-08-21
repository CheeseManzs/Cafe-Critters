extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Default
	role = ROLE.Unique
	description = "40% Attack, Empowered: Empower the next card played."
	name = "Espresso"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	#create status object
	var attackPower : int = ceil(0.4*attacker.getAttack())
	defender.receiveDamage(attackPower,attacker)
	if statusConditions.has(Status.EFFECTS.EMPOWER):
		attacker.addStatusCondition(Status.new(Status.EFFECTS.EMPOWER))
	
	return 0
