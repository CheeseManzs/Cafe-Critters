class_name ControlChart
extends Control


var data = []
var dataLabels = []
var polygonList: PackedVector2Array = []
var colorList: PackedColorArray = []
var barSizes = []
var lastDelta = 0
@export var textObj: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var polyPos: PackedVector2Array = []
	var chartCenter: Vector2 = size/2
	for i in len(data):
		var angle = i*2*PI/float(len(data))
		var vec = chartCenter + data[i]*10.0*Vector2(cos(angle),sin(angle))
		polyPos.append(vec)
	
	polygonList = polyPos
	colorList = [Color.WHITE]
	queue_redraw()
	lastDelta = delta
	pass
	
func createText(pos: Vector2) -> RichTextLabel:
	var newText: RichTextLabel = textObj.instantiate()
	add_child(newText)
	newText.position = pos
	return newText

func reset() -> void:
	barSizes = []

func _draw() -> void:
	#canvas.draw_polygon(polyPos,[Color.WHITE])
	for child in get_children():
		child.queue_free()
	
	var chartCenter: Vector2 = size/2
	var index = 0

	for statIndex in len(data):
		if statIndex >= len(barSizes):
			barSizes.append(0)
		var length = 4*data[statIndex]/30.0
		if statIndex == 2: #HP
			length = 4*data[statIndex]/100.0
		barSizes[statIndex] = lerpf(barSizes[statIndex],length,lastDelta*2)
	
	var polyPoints = []
	var polyLines = []
	var maxLines = []
	
	for stat in data:
		#var pos = Vector2(50,55*(index+1))
		#var barSize = Vector2(20*barSizes[index], 50)
		#var rect: Rect2 = Rect2(pos.x,pos.y,barSize.x,barSize.y)
		#draw_rect(rect,Color.DIM_GRAY)
		var distanceScaler = 20.0
		var angle = index*2*PI/float(len(data)) + PI/6
		var point = chartCenter + distanceScaler * Vector2(cos(angle),sin(angle))*barSizes[index]
		var maxPoint = chartCenter + distanceScaler * Vector2(cos(angle),sin(angle))*sqrt(20)
		var maxTextPoint = chartCenter + distanceScaler * Vector2(cos(angle),sin(angle))*(sqrt(20) + 1) + Vector2(-8,0)
		var textPos = chartCenter + distanceScaler * Vector2(cos(angle),sin(angle))*(barSizes[index] + 0.5) + Vector2(-4,0)
		#createText(textPos).text = str(stat)
		var labelText = createText(maxTextPoint)
		labelText.text = str(dataLabels[index])
		
		polyPoints.append(point)
		polyLines.append(point)
		maxLines.append(maxPoint)
		index += 1 
	
	var maxPoly = maxLines
	if len(polyLines) > 0:
		polyLines.append(polyLines[0])
		maxLines.append(maxLines[0])
	
	if len(polyLines) > 2:	
		draw_polygon(maxPoly, [Color(100,100,100,0.2)])
	
	
		for i in 3:
			var scale = i/3.0
			var midPoints = []
			for point in maxLines:
				var midPoint = (point - chartCenter)*scale + chartCenter
				midPoints.append(midPoint)
			draw_polyline_colors(midPoints, [Color(200, 200, 200, 0.5)],1)
	
	
		draw_polygon(polyPoints, [Color(0,0,100,0.3)])
		draw_polyline_colors(polyLines, [Color.GRAY],2)
		draw_polyline_colors(maxLines, [Color.WEB_GRAY],1.5)
		draw_circle(chartCenter,2,Color.WHITE)
	pass
