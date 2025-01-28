class_name HeatGaugeBar
extends HeatGauge

var xVel = 0
var maxSpeed = 250
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print("bar: ",progress)
	var targetX = global_position.x + 0.95*size.x*(progress) - gaugePivot.size.x/2
	xVel += (targetX - gaugePivot.global_position.x)*delta*100 - 5*xVel*delta
	if abs(xVel) > maxSpeed:
		xVel = sign(xVel)*maxSpeed
	gaugePivot.global_position = Vector2(gaugePivot.global_position.x + xVel*delta,gaugePivot.global_position.y)
	pass
