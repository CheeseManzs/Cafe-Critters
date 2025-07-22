class_name Util

static func linearMap(x: float, low, high):
	return low + x*(high - low)

static func abstractSum(arr: Array):
	var x = arr[0]
	for elementIndex in len(arr):
		if elementIndex > 0:
			x += arr[elementIndex]
	return x

static func abstractScale(arr: Array, scaler: float) -> Array:
	var x = arr.duplicate(true)
	for elementIndex in len(arr):
		x[elementIndex] *= scaler
	return x

static func abstractScaleByElement(arr: Array, scaler: Array) -> Array:
	var x = arr.duplicate(true)
	for elementIndex in len(arr):
		x[elementIndex] *= scaler[elementIndex]
	return x

static func abstractSumByElement(arr: Array, additive: Array) -> Array:
	var x = arr.duplicate(true)
	for elementIndex in len(arr):
		x[elementIndex] += additive[elementIndex]
	return x

static func abstractTransformByElement(arr: Array, T: Callable) -> Array:
	var x = arr.duplicate(true)
	for elementIndex in len(arr):
		x[elementIndex] = T.call(x[elementIndex])
	return x

static func abstractVector3ByElement(vec: Vector3, T: Callable) -> Vector3:
	return Vector3(T.call(vec.x),T.call(vec.y),T.call(vec.z))


static func toInt(x) -> int:
	return int(x)

static func reciprocal(x) -> float:
	return 1.0/x;

static func reverseDictionary(dict: Dictionary) -> Dictionary:
	var newDict = {}
	for key in dict.keys():
		newDict[dict[key]] = key
	return newDict

static var alignmentToString: Dictionary[Card.ALIGNMENT, String] = {
	Card.ALIGNMENT.Default: 	"DE",
	Card.ALIGNMENT.Mise: 	"MI",
	Card.ALIGNMENT.Rea: 		"RE",
	Card.ALIGNMENT.Anvi: 	"AN",
	Card.ALIGNMENT.Sec: 		"SE",
	Card.ALIGNMENT.Eco: 		"EC",
	Card.ALIGNMENT.Jacks: 	"JA",
	Card.ALIGNMENT.Kress: 	"KR",
	Card.ALIGNMENT.Blanc: 	"BL"
}

static var itemTierToString: Dictionary[HeldItem.TIER, String] = {
	HeldItem.TIER.Mild: "Mild",
	HeldItem.TIER.Balanced: "Balanced",
	HeldItem.TIER.Strong: "Strong",
	HeldItem.TIER.Intense: "Intense",
	HeldItem.TIER.Extreme: "Extreme"
}

static var stringToAlignment: Dictionary = reverseDictionary(alignmentToString)
static var stringToItemTier: Dictionary = reverseDictionary(itemTierToString)
	
