extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Anvi
	role = "Ignetor"
	description = "As an additional cost to play this card, discard a token card and consume 1 Heat. 200% Attack."
	name = "Hammer Head"
	power = 2

func canBePlayed(user: BattleMonster):
	var omenCards = user.getRoleCardsInHand("Token")
	return (user.gravyardSize() >= 1) && (user.getHeat() >= 1)

func effect(attacker: BattleMonster, defender: BattleMonster):
	var dis = await attacker.discardRandomTokenCard()
	if attacker.getHeat() >= 1 && dis != null:
		await attacker.addHeat(-1)
		await dealDamage(attacker,defender)
	elif dis == null:
		BattleLog.log("No token card to discard...")
	elif attacker.getHeat() < 1:
		BattleLog.log("Not enough heat...")
