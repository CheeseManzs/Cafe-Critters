extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Slocha"
	description = "As an additional cost to play this card, exile 12 cards from your graveyard. Empower the next card played."
	name = "Brew"

func effect(attacker: BattleMonster, defender: BattleMonster):
	if attacker.gravyardSize() < 12:
		BattleLog.log("Not enough cards in the graveyard...")
		await attacker.battleController.get_tree().create_timer(1.0).timeout
		return
	
	for i in 12:
		attacker.randomGraveyardCardFromTeam(true)
	BattleLog.log("12 cards have been exiled from the graveyard!")
	await attacker.battleController.get_tree().create_timer(1.0).timeout
	await giveStatus(attacker, Status.EFFECTS.EMPOWER_PLAYED)
	return

func canBePlayed(user: BattleMonster):
	var omenCards = user.getOmenCards()
	return (user.gravyardSize() >= 12)


func calcStatusGiven(attacker: BattleMonster, defender: BattleMonster) -> Status:
	if attacker.gravyardSize() >= 12:
		return Status.new(Status.EFFECTS.EMPOWER_PLAYED)
	return null
