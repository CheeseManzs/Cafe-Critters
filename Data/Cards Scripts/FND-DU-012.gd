extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Default
	role = ROLE.Unique
	description = "Consume all Regen.  (10% + 20% per Regen consumed) Attack."
	name = "Boiling Point"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	#calc attack power
	var attackPerc = 0.1
	if attacker.hasStatus(Status.EFFECTS.REGEN):
		var regStatus = attacker.getStatus(Status.EFFECTS.REGEN)
		attackPerc += 0.1*regStatus.X
		regStatus.X = 0
		regStatus.effectDone = true
	
	#deal damage
	var attackPower = attackPerc*attacker.getAttack()
	
	if statusConditions.has(Status.EFFECTS.EMPOWER):
		attackPower = ceil(attackPower*1.5)
		
	await defender.receiveDamage(attackPower, attacker)
	return attackPower

func calcDamage(attacker: BattleMonster, defender: BattleMonster) -> int:
	var attackPerc = 0.1
	if attacker.hasStatus(Status.EFFECTS.REGEN):
		var regStatus = attacker.getStatus(Status.EFFECTS.REGEN)
		attackPerc += 0.1*regStatus.X
	
	#deal damage
	var attackPower = attackPerc*attacker.getAttack()
	
	if statusConditions.has(Status.EFFECTS.EMPOWER):
		attackPower = ceil(attackPower*1.5)
	return attackPower

#checks what status will be removed from the user
func calcStatusCured(attacker: BattleMonster, defender: BattleMonster) -> Status.EFFECTS:
	return Status.EFFECTS.REGEN
