extends Reference

var Constants = preload('res://Constants.gd')
var Particle = preload('res://Particle.gd')

var grid = preload('res://Grid.gd').new()
var neighborhoods = []

var number_particles
var particles = []

func _init():
	var _particles = Vector2(Constants.NUMBER_PARTICLES/2, Constants.NUMBER_PARTICLES)
	
	number_particles = _particles.x * _particles.y
	
	var width = Constants.WIDTH / 4.2
	var height = 3 * Constants.HEIGHT / 4.0
	
	var particle_rect = Rect2((Constants.WIDTH - width)/2, Constants.HEIGHT - height, width, height)
	var rect_pos = particle_rect.position
	
	var d = particle_rect.size / _particles
	for i in range(_particles.x):
		for j in range(_particles.y):
			
			#var pos = Vector2(rect_pos.x, rect_pos.y) + Vector2(i,j)*d
			var pos = Vector2(i,j)*d + Vector2(0, 0.25)
			pos.x += rand_range(-0.001,0.001)
			pos.y += rand_range(-0.001,0.001)
			
			particles.append(Particle.new(pos))
	
	grid.update_structure(particles)
	
	if Constants.DEBUG: print('SPH initialized with ' + str(number_particles) + ' particles.')

func attraction_force(position, strength):
	for i in range(number_particles):
		var x = particles[i].position - position
		var dist2 = x.length_squared()
		
		if dist2 < Constants.KERNEL_RANGE * 3:
			particles[i].force += x * strength * particles[i].density

func update(delta, draw_mode=Constants.DRAW_MODE_BLOB):
	#var m = OS.get_ticks_msec()
	
	find_neighborhoods()
	#print('find_neighborhoods takes ' + str(OS.get_ticks_msec() - m) + ' ms.')
	#m = OS.get_ticks_msec()
	
	calculate_density()
	calculate_pressure()
	calculate_force_density(draw_mode)
	integration_step(delta)
	collision_handling()
	
	#breakpoint
	grid.update_structure(particles)
	
	#print('everything else takes ' + str(OS.get_ticks_msec() - m) + ' ms.')
	#m = OS.get_ticks_msec()

func kernel(x=Vector2()):
	var r2 = x.length_squared()
	var h2 = Constants.KERNEL_RANGE * Constants.KERNEL_RANGE
	
	if r2 < 0 || r2 > h2: return 0.0
	
	return Constants.KERNEL_CONST * pow(h2 - r2, 3)

func grad_kernel(x=Vector2()):
	var r = x.length()
	if r == 0.0: return Vector2()
	
	var t2 = x / r;
	var t3 = pow(Constants.KERNEL_RANGE - r, 2)
	
	return -Constants.GRAD_KERNEL_CONST * t2 * t3

func laplace_kernel(x=Vector2()):
	var r = x.length()
	return Constants.GRAD_KERNEL_CONST * (Constants.KERNEL_RANGE-r)

func find_neighborhoods():
	neighborhoods = []
	var maxDist2 = Constants.KERNEL_RANGE * Constants.KERNEL_RANGE
	
	for p in particles:
		var neighbors = []
		var neighboring_cells = grid.get_neighboring_cells(p.position)
		
		for cell in neighboring_cells:
			for index in cell:
				if neighbors.size() >= Constants.MAX_NEIGHBORS: break
				
				var dist2 = p.position.distance_squared_to(particles[index].position)
				if dist2 <= maxDist2:
					neighbors.append(index)
		
		neighborhoods.append(neighbors)

func calculate_density():
	for i in range(number_particles):
		var neighbors = neighborhoods[i]
		var densitySum = 0.0
		
		for j in neighbors:
			
			var x = particles[i].position - particles[j].position
			densitySum += particles[j].mass * kernel(x)
		
		particles[i].density = densitySum

func calculate_pressure():
	for i in range(number_particles):
		particles[i].pressure = max(Constants.STIFFNESS * (particles[i].density - Constants.REST_DENSITY), 0.0)

func calculate_force_density(draw_mode):
	for i in range(number_particles):
		var f_pressure = Vector2()
		var f_viscosity = Vector2()
		var f_gravity = Vector2()
		
		var neighbors = neighborhoods[i]
		for j in neighbors:
			
			var x = particles[i].position - particles[j].position
			
			f_pressure += particles[j].mass * (particles[i].pressure + particles[j].pressure) / (2.0 * particles[j].density) * grad_kernel(x)
			f_viscosity += particles[j].mass * (particles[j].velocity - particles[i].velocity) / particles[j].density * laplace_kernel(x)
		
		f_gravity = particles[i].density * Vector2(0, Constants.GRAVITY)
		
		f_pressure *= -1
		f_viscosity *= Constants.VISCOCITY
		
		particles[i].viscosity = f_viscosity.length()
		particles[i].force += f_pressure + f_viscosity + f_gravity

func integration_step(delta):
	for i in range(number_particles):
		particles[i].velocity += delta * particles[i].force / particles[i].density
		particles[i].position += delta * particles[i].velocity
		
		particles[i].force *= 0

func collision_handling():
	for i in range(number_particles):
		
		if particles[i].position.x < 0:
			particles[i].position.x = 0
			particles[i].velocity.x *= -0.1
		elif particles[i].position.x > Constants.WIDTH:
			particles[i].position.x = Constants.WIDTH
			particles[i].velocity.x *= -0.1
		
		if particles[i].position.y < 0:
			particles[i].position.y = 0
			particles[i].velocity.y *= -0.1
		elif particles[i].position.y > Constants.HEIGHT:
			particles[i].position.y = Constants.HEIGHT
			particles[i].velocity.y *= -0.1