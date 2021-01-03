extends Reference

var Particle = preload('res://addons/sph_fluid/scripts/SPH/particle.gd')
var Constants = preload('res://addons/sph_fluid/scripts/constants.gd')

var default_scale = Vector2(1,1)/64.0 * Constants.KERNEL_RANGE * Constants.SCALE
var water_texture
var particle_mat
var liquid_view

#interpolation value between current particle position and SPH's particle position
var i_reset = 1.0

func _init(liquid_viewZ):
	water_texture = preload("res://addons/sph_fluid/sprites/halo.png")
	particle_mat = CanvasItemMaterial.new()
	particle_mat.blend_mode = particle_mat.BLEND_MODE_ADD

	liquid_view = liquid_viewZ
	pass

func render(particles):
	for particle in particles:
		var waterdraw = Sprite.new()
		waterdraw.texture = water_texture
		waterdraw.material = particle_mat
		waterdraw.position = particle.position * Constants.SCALE
		waterdraw.scale = default_scale
		liquid_view.add_child(waterdraw)

func update(particle_index, particle_position, draw_point):
	draw_point.position = (1 - i_reset)*draw_point.position + i_reset*(particle_position * Constants.SCALE)
	#draw_point.modulate = SPH.particles[p].get_color(display_mode)


func render_speed_based_particles(particle_index , particle_velocity, draw_point):
	#var draw_point = liquid_view.get_child(particle_index)

	draw_point.look_at(particle_velocity + draw_point.position)
	draw_point.scale = default_scale
	draw_point.scale.x *= 1 + particle_velocity.length()


