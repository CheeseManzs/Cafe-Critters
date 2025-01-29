class_name HeatGaugeBar
extends HeatGauge

var xVel = 0
var maxSpeed = 250
var targSize = 0

func calcX(prog) -> float:
	if flipped:
		return global_position.x - size.x*(prog) + gaugePivot.size.x/2
	else:
		return global_position.x + size.x*(prog) - gaugePivot.size.x/2
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _ready() -> void:
	targSize = custom_minimum_size.y
	custom_minimum_size.y = 0 
	pass # Replace with function body.
	
func _process(delta: float) -> void:
	custom_minimum_size.y = lerp(custom_minimum_size.y, targSize,delta*4)
	var targetX = calcX(progress)
	var sig = 1
	if flipped:
		sig = -1
	var maxX = calcX(1)
	var minX = calcX(0)
	xVel += (targetX - gaugePivot.global_position.x)*delta*100 - 5*xVel*delta
	if abs(xVel) > maxSpeed:
		xVel = sign(xVel)*maxSpeed
	if (!flipped && gaugePivot.global_position.x > maxX) || (flipped && gaugePivot.global_position.x < maxX):
		gaugePivot.global_position.x = maxX
		xVel *= -1.5
	if (!flipped && gaugePivot.global_position.x < minX) || (flipped && gaugePivot.global_position.x > minX):
		gaugePivot.global_position.x = minX
		xVel *= -1.5
	
	gaugePivot.global_position = Vector2(gaugePivot.global_position.x + xVel*delta,gaugePivot.global_position.y)
	#gaugePivot.global_position = Vector2(calcX(1),gaugePivot.global_position.y)
	pass
