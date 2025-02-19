extends Card

func _init() -> void:
	cost = 3
	priority = 0
	alignment = ALIGNMENT.Default
	role = ROLE.Unique
	description = "Consume all Regen. Draw 1 card per Regen consumed."
	name = "Sip"
	selfTarget = true

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	#calc attack power
	var toDraw = 0
	if attacker.hasStatus(Status.EFFECTS.REGEN):
		var regStatus = attacker.getStatus(Status.EFFECTS.REGEN)
		toDraw += regStatus.X
		regStatus.X = 0
		regStatus.effectDone = true
	
	#draw cards
	attacker.drawCards(toDraw)
	return toDraw

#checks what status will be removed from the user
func calcStatusCured(attacker: BattleMonster, defender: BattleMonster) -> Status.EFFECTS:
	return Status.EFFECTS.REGEN
