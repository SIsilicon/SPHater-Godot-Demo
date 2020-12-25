extends Node

var Constants = preload('res://scripts/Constants.gd')
var SPH = preload('res://scripts/SPH/Solver.gd').new()

var default_scale = Vector2(1,1)/64.0 * Constants.KERNEL_RANGE * Constants.SCALE
var display_mode = Constants.DRAW_MODE_BLOB
var particle_mat = CanvasItemMaterial.new()

var first_few_frames = true
var paused = false

#interpolation value between current particle position and SPH's particle position
var i_reset = 1.0

func _ready():
	particle_mat.blend_mode = particle_mat.BLEND_MODE_ADD
	
	$View.size = Vector2(Constants.RENDER_WIDTH, Constants.RENDER_HEIGHT)
	OS.window_size = $View.size
	
	for p in SPH.particles:
		var waterdraw = Sprite.new()
		waterdraw.texture = preload("res://sprites/halo.png")
		waterdraw.material = particle_mat
		
		waterdraw.position = p.position * Constants.SCALE
		waterdraw.scale = default_scale
		$View.add_child(waterdraw)


func _physics_process(delta):	
	if !paused: update_fluid(delta)
	
	for p in range(SPH.particles.size()):
		var draw_point = $View.get_child(p)

		draw_point.position = (1 - i_reset)*draw_point.position + i_reset*(SPH.particles[p].position * Constants.SCALE)
		draw_point.modulate = SPH.particles[p].get_color(display_mode)
		
		#uncomment for speed-based distorted water particles
		#draw_point.look_at(SPH.particles[p].velocity + draw_point.position)
		#draw_point.scale = default_scale
		#draw_point.scale.x *= 1 + SPH.particles[p].velocity.length()


func update_fluid(delta):
	SPH.update(Constants.TIMESTEP if first_few_frames else delta, display_mode)
	
	if Engine.get_frames_drawn() == 5: first_few_frames = false
