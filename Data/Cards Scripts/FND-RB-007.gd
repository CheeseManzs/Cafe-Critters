extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Rea
	role = "Basic"
	description = "Omen. Opponent discards 1."
	name = "Relentless Thoughts"
	tags = ['Utility', 'Omen']
	rarity = RARITY.Common

func effect(attacker: BattleMonster, defender: BattleMonster):
	var toDiscard = await defender.battleController.chooseCards(1, defender.playerControlled)
	if len(toDiscard) > 0:
		await defender.discardCard(toDiscard[0])
