extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Rea
	role = "Basic"
	description = "Omen. 0% Attack"
	name = "Toll the Bell"
	tags = ["Omen"]

func effect(attacker: BattleMonster, defender: BattleMonster):
	if tags.has("Omen"):
		BattleLog.singleton.log("Rea's bells ring in the distance...")
		await attacker.battleController.get_tree().create_timer(1.0).timeout
		await applyOmen(attacker, defender)

func descAttackCalc(attacker: BattleMonster, defender: BattleMonster, atkNum: float):
	return omenCalc(attacker, defender)
