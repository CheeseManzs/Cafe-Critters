class_name HeatGaugeBar
extends HeatGauge

var xVel = 0
var maxSpeed = 250

func calcX(prog) -> float:
	return global_position.x + size.x*(prog) - gaugePivot.size.x/2
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print("bar: ",progress)
	var targetX = calcX(progress)
	var maxX = calcX(1)
	var minX = calcX(0)
	xVel += (targetX - gaugePivot.global_position.x)*delta*100 - 5*xVel*delta
	if abs(xVel) > maxSpeed:
		xVel = sign(xVel)*maxSpeed
	if gaugePivot.global_position.x > maxX:
		gaugePivot.global_position.x = maxX
		xVel *= -1.5
	if gaugePivot.global_position.x < minX:
		gaugePivot.global_position.x = minX
		xVel *= -1.5
	gaugePivot.global_position = Vector2(gaugePivot.global_position.x + xVel*delta,gaugePivot.global_position.y)
	pass
