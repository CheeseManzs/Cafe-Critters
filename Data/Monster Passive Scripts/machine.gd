class_name MachineAbility
extends PassiveAbility

var heat = 0
var minHeat = 0
var maxHeat = 5
var bonusScale = 0
var heatGauge: HeatGauge
var resetHeat = false
var lostHeat = false

@export var heatGaugePrefab: PackedScene
@export var startUpSound: AudioStream

func _init() -> void:
	name = "Machine"
	desc = "Heat Guage" 
		
func heatProgress():
	return (heat - minHeat)/(maxHeat - minHeat + 0.0)

func setHeat(newHeat, mon: BattleMonster, battle: BattleController):
	if mon.hasStatus(Status.EFFECTS.OVERHEAT):
		return
	if newHeat > heat:
		BattleLog.singleton.log(mon.rawData.name + "'s heat rose to " + str(min(maxHeat, newHeat)))
		battle.playSound(battle.powerUpSound)
	if newHeat < heat:
		BattleLog.singleton.log(mon.rawData.name + "'s heat dropped to " + str(max(minHeat,newHeat)))
		battle.playSound(battle.powerDownSound)
	heat = newHeat
	if heat < minHeat:
		heat = minHeat
	if heat > maxHeat:
		heat = maxHeat
	
	if heatGauge != null:
		heatGauge.progress = heatProgress()
		await battle.get_tree().create_timer(1.0).timeout

	if newHeat > maxHeat:
		resetHeat = true
		await mon.addStatusCondition(Status.new(Status.EFFECTS.OVERHEAT),true)


func createGuage(mon: BattleMonster, battle: BattleController):
	heatGauge = await createUI(mon, battle, heatGaugePrefab)
	heatGauge.flipped = !mon.playerControlled

func customUI(mon: BattleMonster, battle: BattleController):
	await battle.get_tree().create_timer(1.0).timeout
	#await EffectFlair.singleton._runFlair("Machine",Color.WEB_GRAY)
	BattleLog.singleton.log(mon.rawData.name+"'s engine bursts to life!")
	mon.battleController.playSound(startUpSound)
	await createGuage(mon, battle)
	heatGauge.progress = heatProgress()
	
func activateAbility(mon: BattleMonster, battle: BattleController) -> void:
	#await customUI(mon, battle)
	await setHeat(0, mon, battle)
	return

func loseHeat(mon: BattleMonster, battle: BattleController) -> void:
	if lostHeat:
		if !mon.hasStatus(Status.EFFECTS.OVERHEAT):
			await setHeat(heat - 1, mon, battle)
		lostHeat = false
	return

func onSubTurnEnd(mon: BattleMonster, battle: BattleController) -> void:
	await loseHeat(mon, battle)
	
func overHeatBonus(mon: BattleMonster, battle: BattleController):
	if mon.hasStatus(Status.EFFECTS.OVERHEAT):
		return 0.25
	else:
		return 0

func heatBoost(mon: BattleMonster, battle: BattleController):
	if mon.hasStatus(Status.EFFECTS.OVERHEAT):
		return 0
	if heat < 5:
		return 0.05*heat
	elif heat >= 5:
		return 0.5

func getBonusScale(mon: BattleMonster):
	if !mon.hasStatus(Status.EFFECTS.OVERHEAT):
		bonusScale = 1
	else:
		bonusScale = 0
	return bonusScale

func attackBonus(mon: BattleMonster, battle: BattleController) -> float:
	return (overHeatBonus(mon, battle) + heatBoost(mon, battle))*getBonusScale(mon)
	
func defenseBonus(mon: BattleMonster, battle: BattleController) -> float:
	return (overHeatBonus(mon, battle) + heatBoost(mon, battle))*getBonusScale(mon)

func beforeAttack(mon: BattleMonster, battle: BattleController, card: Card) -> void:
	if !mon.hasStatus(Status.EFFECTS.OVERHEAT) && (card.power > 0 || card.shieldPower > 0):
		BattleLog.log(mon.rawData.name + "'s " + card.name + " is heating up!")
		lostHeat = true
	return

func onTurnEnd(mon: BattleMonster, battle: BattleController) -> void:
	#temporary
	if mon.isKO():
		return
	
	if resetHeat:
		resetHeat = false
		await setHeat(0, mon, battle)
		return
	
	await createSpecialFlair("Machine", Color.WEB_GRAY)
	
	var discardCards = mon.currentHand.storedCards
	if len(discardCards) > 0:
		await mon.raiseAnimation()
		var cardCount = len(discardCards)
		for i in range(len(discardCards)):
			await mon.quick_discardAnimation(discardCards[i])
			await mon.getPassive().onDiscard(mon,battle,discardCards[i])
			await mon.getHeldItem().getPassive().onDiscard(mon,battle,discardCards[i])
		
		
		await mon.currentHand.removeCards(discardCards)
		await battle.get_tree().create_timer(1.0).timeout
		await setHeat(heat + cardCount, mon, battle)
	
	if mon.hasStatus(Status.EFFECTS.OVERHEAT):
		mon.getStatus(Status.EFFECTS.OVERHEAT).X -= 1
		if mon.getStatus(Status.EFFECTS.OVERHEAT).X < -1:
			mon.getStatus(Status.EFFECTS.OVERHEAT).effectDone = true
			await setHeat(0,mon,battle)
	return
