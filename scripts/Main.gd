extends Node2D

var Constants = preload('res://scripts/Constants.gd')
var SPH = preload('res://scripts/SPH/Solver.gd').new()

var default_scale = Vector2(1,1)/64.0 * Constants.KERNEL_RANGE * Constants.SCALE
var display_mode = Constants.DRAW_MODE_BLOB
var particle_mat = CanvasItemMaterial.new()

var first_few_frames = true
var paused = false

#interpolation value between current particle position and SPH's particle position
var i_reset = 1.0

onready var liquid_view = $LiquidView
onready var view = get_node('../View')

func _ready():
	particle_mat.blend_mode = particle_mat.BLEND_MODE_ADD
	
	for p in SPH.particles:
		var waterdraw = Sprite.new()
		waterdraw.texture = preload("res://sprites/halo.png")
		waterdraw.material = particle_mat
		
		waterdraw.position = p.position * Constants.SCALE
		waterdraw.scale = default_scale
		liquid_view.add_child(waterdraw)	


func _physics_process(delta):	
	var space_state = get_world_2d().direct_space_state
	
	if !paused: update_fluid(delta)
	
	for p in range(SPH.particles.size()):
		var draw_point = liquid_view.get_child(p)

		draw_point.position = (1 - i_reset)*draw_point.position + i_reset*(SPH.particles[p].position * Constants.SCALE)
		draw_point.modulate = SPH.particles[p].get_color(display_mode)

		#uncomment for speed-based distorted water particles
		#render_speed_based_particles(p , draw_point)
		
		var intersections = space_state.intersect_point(
			draw_point.position, 
			32, 
			[], 
			0x7FFFFFFF, 
			true, 
			true)
	
		
		if not intersections.empty():			
			# se a parede está a direita
			if SPH.particles[p].velocity.x > 0:
				#SPH.particles[p].position.x -= 1
				SPH.particles[p].velocity.x *= -0.1

			# se a parede está a esquerda
			if SPH.particles[p].velocity.x < 0:
				SPH.particles[p].velocity.x *= -0.1

			# se a parede está acima
			if SPH.particles[p].velocity.y > 0:
				SPH.particles[p].velocity.y *= -0.1
				
			# se a parede está abaixo
			if SPH.particles[p].velocity.y > 0:
				SPH.particles[p].velocity.y *= -0.1					
		


func update_fluid(delta):
	SPH.update(Constants.TIMESTEP if first_few_frames else delta, display_mode)
	
	if Engine.get_frames_drawn() == 5: first_few_frames = false


func _on_LiquidView_body_entered(body):
	print(body)
	pass # Replace with function body.


func render_speed_based_particles(p , draw_point):
	draw_point.look_at(SPH.particles[p].velocity + draw_point.position)
	draw_point.scale = default_scale
	draw_point.scale.x *= 1 + SPH.particles[p].velocity.length()

