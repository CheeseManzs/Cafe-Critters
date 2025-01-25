extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Forward"
	description = "When you play this card, you can no longer play other cards for the rest of the turn. 100% Attack"
	name = "Last Stand"
	
	power = 1

func effect(attacker: BattleMonster, defender: BattleMonster):
	await dealDamage(attacker, defender)
	attacker.addStatusCondition(Status.new(Status.EFFECTS.CANT_PLAY))

#checks what status will be given to the user
func calcStatusGiven(attacker: BattleMonster, defender: BattleMonster) -> Status:
	return Status.new(Status.EFFECTS.CANT_PLAY)
