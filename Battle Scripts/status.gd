class_name Status
#enum of status effects
enum EFFECTS {
	NONE,
	KO, #mon hp is 0
	DECAY,
	EMPOWER,
	EMPOWER_NEXT,
	EMPOWER_PLAYED,
	HASTE,
	SLOW,
	SUSPEND,
	BOIL,
	DREDGE,
	FLOTSAM,
	SALVAGE,
	PITCH,
	KNOWLEDGE,
	BARRIER,
	REGEN,
	BECOME_RECKLESS,
	RECKLESS,
	STRONGARM,
	TAGGED,
	PRIORITY,
	CANT_PLAY,
	OVERHEAT,
	ENDLESS_BLOWS
}
var X: int = 0
var Y: int = 0
var effectDone = false
var effect: EFFECTS
#checks if effect is numerable (i.e has X after it, like Decay X or Haste X)
static func isNumerable(eff) -> bool:
	if [EFFECTS.DECAY, EFFECTS.SLOW, EFFECTS.SUSPEND, EFFECTS.DREDGE, EFFECTS.BARRIER, EFFECTS.REGEN].has(eff):
		return true
	else:
		return false

func appliesToCards() -> bool:
	if [EFFECTS.HASTE, EFFECTS.SLOW, EFFECTS.EMPOWER, EFFECTS.SALVAGE].has(effect):
		return true
	else:
		return false

func _init(eff: EFFECTS, p_X:int = 0, p_Y:int = 0):
	effect = eff
	X = p_X
	Y = p_Y

func toMini() -> String:
	match effect:
		EFFECTS.KO:
			return "KO"
		EFFECTS.DECAY:
			return "DEC"
		EFFECTS.EMPOWER:
			return "EMP"
		EFFECTS.EMPOWER_NEXT:
			return "EMP+"
		EFFECTS.EMPOWER_PLAYED:
			return "EMP+"
		EFFECTS.HASTE:
			return "HST"
		EFFECTS.SLOW:
			return "SLW"
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
	return "N/A"
	

func rawToString() -> String:
	match effect:
		EFFECTS.KO:
			return "Knocked Out"
		EFFECTS.DECAY:
			return "Decay"
		EFFECTS.EMPOWER:
			return "Empower"
		EFFECTS.EMPOWER_NEXT:
			return "Drawn Empower"
		EFFECTS.EMPOWER_PLAYED:
			return "Empower"
		EFFECTS.HASTE:
			return "Haste"
		EFFECTS.SLOW:
			return "Slow"
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
		EFFECTS.HASTE:
			return true
		EFFECTS.BOIL:
			return true
		EFFECTS.KNOWLEDGE:
			return true
		EFFECTS.BARRIER:
			return true
		EFFECTS.REGEN:
			return true
		EFFECTS.STRONGARM:
			return true
		EFFECTS.PRIORITY:
			return true
	return false

func carriesOverOnSwitch() -> bool:
	match effect:
		EFFECTS.EMPOWER_PLAYED:
			return true
		EFFECTS.HASTE:
			return true
		EFFECTS.SLOW:
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
	return false

func newTurn() -> void:
	#check effect
	match effect:
		EFFECTS.KO:
			return
		EFFECTS.DECAY:
			return
		EFFECTS.EMPOWER:
			return
		EFFECTS.EMPOWER_NEXT:
			return
		EFFECTS.HASTE:
			if X <= 0:
				effectDone = true
			return
		EFFECTS.BOIL:
			effectDone = true
		EFFECTS.SLOW:
			if X <= 0:
				effectDone = true
			return
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
			X -= 1
			return
		EFFECTS.REGEN:
			return
		EFFECTS.STRONGARM:
			return
		EFFECTS.RECKLESS:
			effectDone = true
			return
		EFFECTS.PRIORITY:
			effectDone = true
			return
		EFFECTS.CANT_PLAY:
			effectDone = true
			return
		EFFECTS.OVERHEAT:
			if X > -1:
				X = -1
			else:
				effectDone = true
			return
