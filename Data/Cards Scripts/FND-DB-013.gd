extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Basic"
	description = "When you play this card, your faes can no longer play other cards for the rest of the turn. Deal (100% ATK) damage."
	name = "Last Stand"
	tags = ['Attack']
	rarity = RARITY.Epic
	power = 1

func effect(attacker: BattleMonster, defender: BattleMonster):
	await dealDamage(attacker, defender)
	await giveStatus(attacker, Status.EFFECTS.CANT_PLAY)
	pass

func calcStatusGiven(attacker: BattleMonster, defender: BattleMonster) -> Status:
	return Status.new(Status.EFFECTS.CANT_PLAY)
#checks what status will be inflicted on the defender
func calcStatusInflicted(attacker: BattleMonster, defender: BattleMonster) -> Status:
	return null
