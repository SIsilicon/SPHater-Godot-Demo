extends Node2D

const RenderService = preload('res://addons/sph_fluid/scripts/renderer/RenderService.gd')
const Constants = preload('res://addons/sph_fluid/scripts/Constants.gd')
const SPH_Solver = preload('res://addons/sph_fluid/scripts/SPH/Solver.gd')
const Collision = preload('res://addons/sph_fluid/scripts/collision/Collision.gd')

var default_scale = Vector2(1,1)/64.0 * Constants.KERNEL_RANGE * Constants.SCALE
var display_mode = Constants.DRAW_MODE_BLOB
var particle_mat = CanvasItemMaterial.new()

var first_few_frames = true
var paused = false
var collision

var SPH = SPH_Solver.new()

onready var liquid_view = $LiquidView
onready var view = get_node('../View')

var render_service

func _ready():	
	render_service = RenderService.new(liquid_view)
	render_service.render(SPH.particles)
	collision = Collision.new()

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
		collision.calculate(draw_point, SPH.particles[particle_index], space_state)


func update_fluid(delta):
	SPH.update(Constants.TIMESTEP if first_few_frames else delta, display_mode)
	
	if Engine.get_frames_drawn() == 5: first_few_frames = false


func _on_LiquidView_body_entered(body):
	print(body)
	pass

