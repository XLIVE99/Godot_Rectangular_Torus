extends ImmediateGeometry

export (float) var innerRadius = 1
export (float) var outerRadius = 1.5
export (int) var detail = 36
export (float) var completeProccess = 1
export (float) var animationSpeed = 1

var innerVertexes = []
var outerVertexes = []

func _ready():
	_draw()
	pass

func _auto_normal_triangle_vertex(var vertex1, var vertex2, var vertex3):
#	var edge1 = vertex2 - vertex1
#	var edge2 = vertex3 - vertex2
	set_normal((vertex3 - vertex2).cross(vertex2 - vertex1))
	
	add_vertex(vertex1)
	add_vertex(vertex2)
	add_vertex(vertex3)
	pass

func _draw():
	#Assign vertex positions
	var spaces = 360.0/detail
	var complete = detail * completeProccess
	for i in range((complete + 1) as int):
		var innerPos = Vector3(sin(deg2rad(i * spaces)), cos(deg2rad(i * spaces)), 0) * innerRadius
		innerVertexes.append(innerPos)
		innerVertexes.append(innerPos + Vector3.BACK)
		
		var outerPos = Vector3(sin(deg2rad(i * spaces)), cos(deg2rad(i * spaces)), 0) * outerRadius
		outerVertexes.append(outerPos)
		outerVertexes.append(outerPos + Vector3.BACK)
	
	var lastVertex = completeProccess * 360
	var innerPos = Vector3(sin(deg2rad(lastVertex)), cos(deg2rad(lastVertex)), 0) * innerRadius
	innerVertexes.append(innerPos)
	innerVertexes.append(innerPos + Vector3.BACK)
	
	var outerPos = Vector3(sin(deg2rad(lastVertex)), cos(deg2rad(lastVertex)), 0) * outerRadius
	outerVertexes.append(outerPos)
	outerVertexes.append(outerPos + Vector3.BACK)
	
	begin(Mesh.PRIMITIVE_TRIANGLES)
	#Inner and outer faces
	for i in range(innerVertexes.size() - 2):
		if(i % 2 == 0):
			_auto_normal_triangle_vertex(innerVertexes[i], innerVertexes[i + 1], innerVertexes[i + 2])
			_auto_normal_triangle_vertex(outerVertexes[i], outerVertexes[i + 2], outerVertexes[i + 1])
		else:
			_auto_normal_triangle_vertex(innerVertexes[i], innerVertexes[i + 2], innerVertexes[i + 1])
			_auto_normal_triangle_vertex(outerVertexes[i], outerVertexes[i + 1], outerVertexes[i + 2])
	
	#Back and forward faces
	for i in range((innerVertexes.size() / 2) - 1):
		#Camera side
		_auto_normal_triangle_vertex(innerVertexes[(i * 2) + 1], outerVertexes[(i * 2) + 1], innerVertexes[((i + 1) * 2) + 1])
		_auto_normal_triangle_vertex(innerVertexes[((i + 1) * 2) + 1], outerVertexes[(i * 2) + 1], outerVertexes[((i + 1) * 2) + 1])
		
		#Back side (Non-visible at start)
		_auto_normal_triangle_vertex(innerVertexes[i * 2], innerVertexes[(i + 1) * 2], outerVertexes[i * 2])
		_auto_normal_triangle_vertex(innerVertexes[(i + 1) * 2], outerVertexes[(i + 1) * 2], outerVertexes[i * 2])
	
	#End faces
	if(completeProccess != 1):
		_auto_normal_triangle_vertex(innerVertexes[0], outerVertexes[0], innerVertexes[1])
		_auto_normal_triangle_vertex(innerVertexes[1], outerVertexes[0], outerVertexes[1])
		
		var innerSize = innerVertexes.size()
		var outerSize = outerVertexes.size()
		_auto_normal_triangle_vertex(innerVertexes[innerSize - 2], innerVertexes[innerSize - 1], outerVertexes[outerSize - 2])
		_auto_normal_triangle_vertex(innerVertexes[innerSize - 1], outerVertexes[outerSize - 1], outerVertexes[outerSize - 2])
	end()
	pass

func _process(delta):
	completeProccess += delta * animationSpeed
	if(completeProccess > 1):
		completeProccess = 0.0
	clear()
	innerVertexes.clear()
	outerVertexes.clear()
	_draw()
	pass
