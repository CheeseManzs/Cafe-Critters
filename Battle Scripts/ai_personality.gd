class_name AIPersonality
extends Resource

#leans towards offensive options
@export var aggression: float
#leans towards defensive options
@export var caution: float
#values status conditions more (positively and negatively)
@export var mechanics: float
#will not use moves with low scores (which usually cause it to swap instead)
@export var standards: float

func _init(agg: float = 1, cau: float = 1, mec: float = 1, sta: float = 0):
	aggression = agg
	caution = cau
	mechanics = mec
	standards = sta

func clone() -> AIPersonality:
	var newPersonality = AIPersonality.new(
		aggression, 
		caution, 
		mechanics, 
		standards
	)
	return newPersonality
