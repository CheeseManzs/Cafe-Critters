class_name AIPersonality
extends Resource

##Leans towards offensive options
@export var aggression: float = 1
##Leans towards defensive options
@export var caution: float = 1
##Values status conditions more (Positively and negatively)
@export var mechanics: float = 1
##Will not use moves with low scores (which usually causes it to swap instead)
@export var standards: float = 0

##Advanced personality value. Leans towards dealing fatal damage (damage that will KO that turn)
@export var opportunism: float = 1 

func _init(agg: float = 1, cau: float = 1, mec: float = 1, sta: float = 0, opp: float = 0):
	aggression = agg
	caution = cau
	mechanics = mec
	standards = sta
	opportunism = 0

func clone() -> AIPersonality:
	var newPersonality = AIPersonality.new(
		aggression, 
		caution, 
		mechanics, 
		standards
	)
	return newPersonality
