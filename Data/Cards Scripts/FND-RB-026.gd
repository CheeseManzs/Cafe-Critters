extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Rea
	role = "Basic"
	description = "Omen. Inflict Fear 10, your faes can no longer play any more cards this turn."
	name = "Spooky Stories"
	tags = ['Utility', 'Omen']
	rarity = RARITY.Epic

func effect(attacker: BattleMonster, defender: BattleMonster):
	await applyOmen(attacker, defender)
	await giveStatus(defender, Status.EFFECTS.FEAR, 10)
	await giveStatus(attacker, Status.EFFECTS.CANT_PLAY)

#checks what status will be given to the user
func calcStatusGiven(attacker: BattleMonster, defender: BattleMonster) -> Status:
	return Status.new(Status.EFFECTS.CANT_PLAY)

#checks what status will be inflicted on the defender
func calcStatusInflicted(attacker: BattleMonster, defender: BattleMonster) -> Status:
	return Status.new(Status.EFFECTS.FEAR, 10)
