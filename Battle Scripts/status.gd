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
	TAGGED
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
			return "Empower (Next Drawn)"
		EFFECTS.EMPOWER_PLAYED:
			return "Empower (Next Played)"
		EFFECTS.HASTE:
			return "Haste"
		EFFECTS.SLOW:
			return "Slow"
		EFFECTS.SUSPEND:
			return "Suspend"
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
