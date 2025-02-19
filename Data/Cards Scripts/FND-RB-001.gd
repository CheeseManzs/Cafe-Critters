extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Rea
	role = "Basic"
	description = "Trigger all Omen cards in the graveyard. 0% Attack"
	name = "Toll the Bell"

func effect(attacker: BattleMonster, defender: BattleMonster):
	BattleLog.singleton.log("Rea's bells ring in the distance...")
	await attacker.battleController.get_tree().create_timer(1.0).timeout
	await applyOmen(attacker, defender)

func descAttackCalc(attacker: BattleMonster, defender: BattleMonster, atkNum: float):
	return omenCalc(attacker, defender)
