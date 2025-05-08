extends Card

func _init() -> void:
	cost = 3
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Basic"
	description = "Enemy 300% Attacks you. Draw 5 cards and gain 3 mana."
	name = "Last Chance"
	selfTarget = true

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	#calc attack power
	var dmgTaken = defender.attack*3.00
	#self damage
	attacker.receiveDamage(dmgTaken,defender)
	#draw cards
	attacker.drawCards(5)
	attacker.addMP(3)
	return dmgTaken

#checks what status will be removed from the user
func calcStatusCured(attacker: BattleMonster, defender: BattleMonster) -> Status.EFFECTS:
	return Status.EFFECTS.REGEN
