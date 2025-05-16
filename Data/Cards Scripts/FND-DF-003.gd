extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Forward"
	description = "When you play this card, you can no longer play other cards for the rest of the round. 100% Attack"
	name = "Last Stand"
	
	power = 1

func effect(attacker: BattleMonster, defender: BattleMonster):
	await dealDamage(attacker, defender)
	await giveStatus(attacker,Status.EFFECTS.CANT_PLAY,0,0,false,false)

#checks what status will be given to the user
func calcStatusGiven(attacker: BattleMonster, defender: BattleMonster) -> Status:
	return Status.new(Status.EFFECTS.CANT_PLAY)
