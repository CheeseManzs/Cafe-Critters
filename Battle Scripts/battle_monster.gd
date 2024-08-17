class_name BattleMonster

#link to raw monster data
@export var rawData: Monster
#current deck of the monster
@export var currentDeck: Zone
#current level of the monster
@export var level: int
#current health of the monster
@export var health: int
#monster's current Max HP stat
@export var maxHP: int
#monster's current defense stat
@export var defense: int
#monster's current attack stat
@export var attack: int

func _init(data: Monster) -> void:
	#set raw data
	rawData = data
	#copy data for raw data
	level = 1
	maxHP = rawData.statHealth
	health = maxHP
	defense = rawData.statDefense
	attack = rawData.statAttack
	
