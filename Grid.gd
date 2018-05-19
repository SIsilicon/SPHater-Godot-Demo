extends Reference

var Constants = preload("res://Constants.gd")

var numberCells = Vector2()
var cells = {}

func _init():
	numberCells.x = int(Constants.WIDTH / Constants.KERNEL_RANGE + 1)
	numberCells.y = int(Constants.HEIGHT / Constants.KERNEL_RANGE + 1)
	
	if Constants.DEBUG: print('Grid with ' + str(numberCells.x) + ' x ' + str(numberCells.y) + ' cells created.')

func get_neighboring_cells(position):
	var resultCells = []
	
	var xCell = int(position.x / Constants.KERNEL_RANGE)
	var yCell = int(position.y / Constants.KERNEL_RANGE)
	
	resultCells.append(access_grid(xCell, yCell))
	
	resultCells.append(access_grid(xCell - 1, yCell))
	resultCells.append(access_grid(xCell + 1, yCell))
	
	resultCells.append(access_grid(xCell, yCell - 1))
	resultCells.append(access_grid(xCell, yCell + 1))
	
	resultCells.append(access_grid(xCell - 1, yCell - 1))
	resultCells.append(access_grid(xCell - 1, yCell + 1))
	resultCells.append(access_grid(xCell + 1, yCell - 1))
	resultCells.append(access_grid(xCell + 1, yCell + 1))
	
	return resultCells

func update_structure(particles):
	cells = {}
	
	for i in range(particles.size()):
		var xCell = int(particles[i].position.x / Constants.KERNEL_RANGE)
		var yCell = int(particles[i].position.y / Constants.KERNEL_RANGE)
		
		append_grid(xCell, yCell, i)

func append_grid(x, y, p):
	if not cells.has(Vector2(x, y)):
		cells[Vector2(x, y)] = []
	
	cells[Vector2(x, y)].append(p)

func access_grid(x, y):
	if cells.has(Vector2(x, y)):
		return cells[Vector2(x, y)]
	else:
		return []