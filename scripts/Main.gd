extends Node2D

const RenderService = preload('res://scripts/renderer/RenderService.gd')
var Constants = preload('res://scripts/Constants.gd')
var SPH = preload('res://scripts/SPH/Solver.gd').new()

var default_scale = Vector2(1,1)/64.0 * Constants.KERNEL_RANGE * Constants.SCALE
var display_mode = Constants.DRAW_MODE_BLOB
var particle_mat = CanvasItemMaterial.new()

var first_few_frames = true
var paused = false

onready var liquid_view = $LiquidView
onready var view = get_node('../View')

var render_service

func _ready():	
	render_service = RenderService.new(liquid_view)
	render_service.render(SPH.particles)


func _physics_process(delta):
	if paused: return
		
	update_fluid(delta)
	var space_state = get_world_2d().direct_space_state
	
	for particle_index in range(SPH.particles.size()):
		var draw_point = liquid_view.get_child(particle_index)
				
		render_service.update(
			particle_index, 
			SPH.particles[particle_index].position, 
			draw_point)
		
		#uncomment for speed-based distorted water particles
		# render_service.render_speed_based_particles(
		# 	particle_index, 
		# 	SPH.particles[particle_index].velocity, 
		# 	draw_point)		
		
		# var intersections = space_state.intersect_point(
		# 	draw_point.position, 
		# 	32, 
		# 	[], 
		# 	0x7FFFFFFF, 
		# 	true, 
		# 	true)	
		
		# if not intersections.empty():
		# 	# se a parede está a direita
		# 	if SPH.particles[p].velocity.x > 0:
		# 		#SPH.particles[p].position.x -= 1
		# 		SPH.particles[p].velocity.x *= -0.1

		# 	# se a parede está a esquerda
		# 	if SPH.particles[p].velocity.x < 0:
		# 		SPH.particles[p].velocity.x *= -0.1

		# 	# se a parede está acima
		# 	if SPH.particles[p].velocity.y > 0:
		# 		SPH.particles[p].velocity.y *= -0.1
				
		# 	# se a parede está abaixo
		# 	if SPH.particles[p].velocity.y > 0:
		# 		SPH.particles[p].velocity.y *= -0.1


func update_fluid(delta):
	SPH.update(Constants.TIMESTEP if first_few_frames else delta, display_mode)
	
	if Engine.get_frames_drawn() == 5: first_few_frames = false


func _on_LiquidView_body_entered(body):
	print(body)
	pass

