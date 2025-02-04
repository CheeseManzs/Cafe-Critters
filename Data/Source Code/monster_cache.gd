class_name MonsterCache
extends Resource

@export var cache: Array[Monster]

func toCacheArray(monArr: Array[Monster]) -> Array[int]:
	var cacheArr: Array[int] = []
	for mon in monArr:
		cacheArr.push_back(mon.id)
	return cacheArr
	
func toMonsterArray(cacheArr: Array) -> Array[Monster]:
	var monArr: Array[Monster] = []
	for id in cacheArr:
		monArr.push_back(getMonster(id))
	return monArr


func getMonster(id: int) -> Monster:
	#i know i can just use the index but this is probably easier and safer
	for monster in cache:
		if monster.id == id:
			return monster
	return null
