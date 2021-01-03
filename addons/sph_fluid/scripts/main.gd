extends Node2D

const RenderService = preload('res://addons/sph_fluid/scripts/renderer/RenderService.gd')
const Constants = preload('res://addons/sph_fluid/scripts/Constants.gd')
const SPH_Solver = preload('res://addons/sph_fluid/scripts/SPH/solver.gd')
const Collision = preload('res://addons/sph_fluid/scripts/collision/Collision.gd')

var _collision
var _render_service
var _SPH

onready var liquid_view = $LiquidView

func _ready():	
	_collision = Collision.new()
	_SPH = SPH_Solver.new()
	_render_service = RenderService.new(liquid_view)

	_render_service.render(_SPH.particles)	

func _physics_process(delta):
	_update_fluid(delta)
	var space_state = get_world_2d().direct_space_state
	
	for particle_index in range(_SPH.particles.size()):
		var draw_point = liquid_view.get_child(particle_index)
		
		_collision.calculate(draw_point, _SPH.particles[particle_index], space_state)
		_render(draw_point, particle_index)


func _update_fluid(delta):
	var delta_time = Constants.TIMESTEP if Engine.get_frames_drawn() <= 5 else delta

	_SPH.update(delta_time)

func _render(draw_point, particle_index):				
	_render_service.update(
		particle_index,
		_SPH.particles[particle_index].position,
		draw_point)
