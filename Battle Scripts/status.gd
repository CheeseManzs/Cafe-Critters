class_name Status
#enum of status effects
enum EFFECTS {
	NONE,
	KO, #mon hp is 0
	RIPTIDE,
	EMPOWER,
	EMPOWER_NEXT,
	EMPOWER_PLAYED,
	FOCUS,
	FATIGUE,
	SUSPEND,
	BOIL,
	DREDGE,
	FLOTSAM,
	SALVAGE,
	PITCH,
	KNOWLEDGE,
	BARRIER,
	VEIL,
	REGEN,
	BECOME_RECKLESS,
	RECKLESS,
	STRONGARM,
	TAGGED,
	PRIORITY,
	CANT_PLAY,
	OVERHEAT,
	ENDLESS_BLOWS,
	POISON,
	BURN,
	FEAR,
	NULLIFY_DAMAGE,
	PERFECT_PARRY,
	ATTACK_UP,
	DEFENSE_UP,
	CAFFEINATED_OVERDRIVE,
	INSURANCE
}
var X: int = 0
var Y: int = 0
var effectDone = false
var effect: EFFECTS

#ui connections
var icon: StatusIcon = null

#checks if effect is numerable (i.e has X after it, like Decay X or Focus X)
static func isNumerable(eff) -> bool:
	if [EFFECTS.RIPTIDE, EFFECTS.FATIGUE, EFFECTS.SUSPEND, EFFECTS.DREDGE, EFFECTS.BARRIER, EFFECTS.REGEN, EFFECTS.VEIL].has(eff):
		return true
	else:
		return false

func appliesToCards() -> bool:
	if [EFFECTS.FOCUS, EFFECTS.FATIGUE, EFFECTS.EMPOWER, EFFECTS.SALVAGE].has(effect):
		return true
	else:
		return false

func _init(eff: EFFECTS, p_X:int = 0, p_Y:int = 0):
	effect = eff
	X = p_X
	Y = p_Y

func addX(delta: int):
	setX(X + delta)

func setX(newX: int):
	X = newX
	if X <= 0:
		effectDone = true
	
	if icon != null:
		icon.update(self)

func toMini() -> String:
	match effect:
		EFFECTS.KO:
			return "KO"
		EFFECTS.RIPTIDE:
			return "RPT"
		EFFECTS.EMPOWER:
			return "EMP"
		EFFECTS.EMPOWER_NEXT:
			return "EMP+"
		EFFECTS.EMPOWER_PLAYED:
			return "EMP+"
		EFFECTS.FOCUS:
			return "FCS"
		EFFECTS.FATIGUE:
			return "FTG"
		EFFECTS.SUSPEND:
			return "SSP"
		EFFECTS.BOIL:
			return "BOL"
		EFFECTS.DREDGE:
			return "DRG"
		EFFECTS.FLOTSAM:
			return "FLT"
		EFFECTS.SALVAGE:
			return "SLV"
		EFFECTS.PITCH:
			return "PIT"
		EFFECTS.KNOWLEDGE:
			return "KNW"
		EFFECTS.BARRIER:
			return "BAR"
		EFFECTS.VEIL:
			return "VEL"
		EFFECTS.REGEN:
			return "RGN"
		EFFECTS.BECOME_RECKLESS:
			return "REK+"
		EFFECTS.RECKLESS:
			return "REK"
		EFFECTS.STRONGARM:
			return "STR"
		EFFECTS.TAGGED:
			return "TAG"
		EFFECTS.PRIORITY:
			return "PTY"
		EFFECTS.CANT_PLAY:
			return "CNT"
		EFFECTS.OVERHEAT:
			return "OVH"
		EFFECTS.ENDLESS_BLOWS:
			return "EDB"
		EFFECTS.POISON:
			return "PSN"
		EFFECTS.BURN:
			return "BRN"
		EFFECTS.FEAR:
			return "FER"
		EFFECTS.NULLIFY_DAMAGE:
			return "NLD"
		EFFECTS.PERFECT_PARRY:
			return "PRY"
		EFFECTS.ATTACK_UP:
			return "ATK"
		EFFECTS.DEFENSE_UP:
			return "DEF"
		EFFECTS.CAFFEINATED_OVERDRIVE:
			return "CAF"
		EFFECTS.INSURANCE:
			return "INS"
	return "N/A"
	

func rawToString() -> String:
	match effect:
		EFFECTS.KO:
			return "Knocked Out"
		EFFECTS.RIPTIDE:
			return "Riptide"
		EFFECTS.EMPOWER:
			return "Empower"
		EFFECTS.EMPOWER_NEXT:
			return "Drawn Empower"
		EFFECTS.EMPOWER_PLAYED:
			return "Empower"
		EFFECTS.FOCUS:
			return "Focus"
		EFFECTS.FATIGUE:
			return "Fatigue"
		EFFECTS.SUSPEND:
			return "Suspend"
		EFFECTS.BOIL:
			return "Boil"
		EFFECTS.DREDGE:
			return "Dredge"
		EFFECTS.FLOTSAM:
			return "Flotsam"
		EFFECTS.SALVAGE:
			return "Salvage"
		EFFECTS.PITCH:
			return "Pitch"
		EFFECTS.KNOWLEDGE:
			return "Knowledge"
		EFFECTS.BARRIER:
			return "Barrier"
		EFFECTS.REGEN:
			return "Regen"
		EFFECTS.BECOME_RECKLESS:
			return "Becoming Reckless"
		EFFECTS.RECKLESS:
			return "Reckless"
		EFFECTS.STRONGARM:
			return "Strongarm"
		EFFECTS.PRIORITY:
			return "Priority"
		EFFECTS.CANT_PLAY:
			return "Can't Play"
		EFFECTS.OVERHEAT:
			return "Overheat"
		EFFECTS.ENDLESS_BLOWS:
			return "Endless Blows"
		EFFECTS.POISON:
			return "Poison"
		EFFECTS.BURN:
			return "Burn"
		EFFECTS.FEAR:
			return "Fear"
		EFFECTS.NULLIFY_DAMAGE:
			return "Nullify Next Hit"
		EFFECTS.PERFECT_PARRY:
			return "Perfect Parry"
		EFFECTS.ATTACK_UP:
			return "Attack Up"
		EFFECTS.DEFENSE_UP:
			return "Defense Up"
		EFFECTS.CAFFEINATED_OVERDRIVE:
			return "Caffeinated Overdrive"
		EFFECTS.INSURANCE:
			return "Insurance"
	return "None"

#converts status object to string in the from [STATUS] [X]/[Y]
func toString() -> String:
	var string = rawToString()
	if X > 0:
		string += " " + str(X)
	if X > 0 && Y > 0:
		string += "/" + str(Y)
	elif Y > 0:
		string += " " + str(Y)
	
	return string

func isPositive() -> bool:
	match effect:
		EFFECTS.EMPOWER:
			return true
		EFFECTS.EMPOWER_NEXT:
			return true
		EFFECTS.EMPOWER_PLAYED:
			return true
		EFFECTS.FOCUS:
			return true
		EFFECTS.BOIL:
			return true
		EFFECTS.KNOWLEDGE:
			return true
		EFFECTS.BARRIER:
			return true
		EFFECTS.REGEN:
			return true
		EFFECTS.PRIORITY:
			return true
		EFFECTS.NULLIFY_DAMAGE:
			return true
		EFFECTS.PERFECT_PARRY:
			return true
		EFFECTS.ATTACK_UP:
			return true
		EFFECTS.DEFENSE_UP:
			return true
		EFFECTS.CAFFEINATED_OVERDRIVE:
			return true
	return false

func endsOnSwitch() -> bool:
	match effect:
		EFFECTS.POISON:
			return true
		EFFECTS.RIPTIDE:
			return true
	return false

func carriesOverOnSwitch() -> bool:
	match effect:
		EFFECTS.EMPOWER_PLAYED:
			return true
		EFFECTS.FOCUS:
			return true
		EFFECTS.FATIGUE:
			return true
		EFFECTS.BOIL:
			return true
		EFFECTS.KNOWLEDGE:
			return true
		EFFECTS.BARRIER:
			return true
		EFFECTS.REGEN:
			return true
		EFFECTS.CANT_PLAY:
			return true
		EFFECTS.ENDLESS_BLOWS:
			return true
		EFFECTS.FEAR:
			return true
		EFFECTS.INSURANCE:
			return true
	return false

func newSubTurn() -> void:
	match effect:
		EFFECTS.PERFECT_PARRY:
			effectDone = true
		EFFECTS.FATIGUE:
			if X <= 0:
				effectDone = true
		EFFECTS.FOCUS:
			if X <= 0:
				effectDone = true
		EFFECTS.PRIORITY:
			if X == 0:
				effectDone = true
			X -= 1
			return
		EFFECTS.POISON:
			if X < 1:
				effectDone = true
		EFFECTS.BURN:
			if X < 1:
				effectDone = true
		EFFECTS.FEAR:
			if X < 1:
				effectDone = true
			return

func newTurn() -> void:
	#check effect
	match effect:
		EFFECTS.KO:
			return
		EFFECTS.RIPTIDE:
			return
		EFFECTS.EMPOWER:
			return
		EFFECTS.EMPOWER_NEXT:
			return
		EFFECTS.FOCUS:
			if X <= 0:
				effectDone = true
			return
		EFFECTS.BOIL:
			effectDone = true
		EFFECTS.FATIGUE:
			if X <= 0:
				effectDone = true
			return
		EFFECTS.CANT_PLAY:
			effectDone = true
		EFFECTS.SUSPEND:
			return
		EFFECTS.DREDGE:
			return
		EFFECTS.FLOTSAM:
			return
		EFFECTS.SALVAGE:
			return
		EFFECTS.PITCH:
			return
		EFFECTS.KNOWLEDGE:
			return
		EFFECTS.BARRIER:
			addX(-1)
			return
		EFFECTS.REGEN:
			return
		EFFECTS.STRONGARM:
			effectDone = true
			return
		EFFECTS.RECKLESS:
			effectDone = true
			return
		EFFECTS.OVERHEAT:
			return
		EFFECTS.NULLIFY_DAMAGE:
			effectDone = true
		EFFECTS.PERFECT_PARRY:
			effectDone = true
		EFFECTS.CAFFEINATED_OVERDRIVE:
			effectDone = true
		EFFECTS.INSURANCE:
			effectDone = true
