extends PassiveAbility

var heat = 3
var minHeat = 1
var maxHeat = 5
var heatGauge: HeatGauge
@export var heatGaugePrefab: PackedScene

func _init() -> void:
	name = "Machine"
	desc = "Heat Guage" 

func setHeat(newHeat, mon: BattleMonster, battle: BattleController):
	if newHeat > heat:
		BattleLog.singleton.log(mon.rawData.name + "'s heat raised to " + str(newHeat))
	else:
		BattleLog.singleton.log(mon.rawData.name + "'s heat dropped to " + str(newHeat))
	heat = newHeat
	if heat < minHeat:
		heat = minHeat
	if heat > maxHeat:
		heat = maxHeat
	heatGauge.progress = (heat - minHeat)/(maxHeat - minHeat + 0.0)
	await battle.get_tree().create_timer(1.0).timeout

func createGuage(mon: BattleMonster, battle: BattleController):
	var container: VBoxContainer
	if mon.playerControlled:
		container = battle.playerUI[0].externalGaugeContainer
	else:
		container = battle.enemyUI[0].externalGaugeContainer 
	
	heatGauge = heatGaugePrefab.instantiate()
	container.add_child(heatGauge)

func activateAbility(mon: BattleMonster, battle: BattleController) -> void:
	BattleLog.singleton.log(mon.rawData.name+"'s engine bursts to life!")
	await createGuage(mon, battle)
	await setHeat(5, mon, battle)
	return

func onSubTurnStart(mon: BattleMonster, battle: BattleController) -> void:
	await setHeat(heat - 1, mon, battle)
	return

func onHit(mon: BattleMonster, battle: BattleController) -> void:
	await setHeat(5, mon, battle)
	return
