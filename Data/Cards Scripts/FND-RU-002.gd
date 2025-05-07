extends Card

func _init() -> void:
	cost = 5
	priority = 0
	alignment = ALIGNMENT.Rea
	role = "Rev"
	description = "Omen. (25% per Omen card in graveyard) Attack."
	name = "Revenant Fury"
	tags=["Omen"]

func effect(attacker: BattleMonster, defender: BattleMonster):
	var attackPower = 0.25*len(getOmenCards(attacker.battleController))
	if attackPower > 0:
		await dealDamage(attacker, defender, attackPower)
	await applyOmen(attacker, defender)

func calcDamage(attacker: BattleMonster, defender: BattleMonster):
	return _calcPower(attacker, defender, 0.25*len(getOmenCards(attacker.battleController))) + omenCalc(attacker, defender)

func setDescription(attacker: BattleMonster, defender: BattleMonster):
	descSetup()
	var tooltip = "[hint={ratio}][color={col}]".format({"ratio": "25% per Omen card in graveyard", "col": tooltipColors["Attack"]})
	description = description.replace("(25% per Omen card in graveyard) Attack",tooltip+str(calcDamage(attacker, defender))+" Damage[/color][/hint]")
	genericDescription(attacker, defender)
	
	
	
