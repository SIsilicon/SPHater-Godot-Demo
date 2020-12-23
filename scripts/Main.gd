extends Node

var Constants = preload('res://scripts/Constants.gd')

var SPH = preload('res://scripts/SPH/SPHsolver.gd').new()

var default_scale = Vector2(1,1)/64.0 * Constants.KERNEL_RANGE * Constants.SCALE
var display_mode = Constants.DRAW_MODE_BLOB
var particle_mat = CanvasItemMaterial.new()

var first_few_frames = true
var paused = false

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
	
	$mouse.scale /= 32.0
	$mouse.scale *= 3 * Constants.KERNEL_RANGE * Constants.SCALE

#interpolation value between current particle position and SPH's particle position
var i_reset = 1.0

func _physics_process(delta):
	
	handle_input()
	
	if !paused: update_fluid(delta)
	
	for p in range(SPH.particles.size()):
		var draw_point = $View.get_child(p)
		
		draw_point.position = (1 - i_reset)*draw_point.position + i_reset*(SPH.particles[p].position * Constants.SCALE)
		draw_point.modulate = SPH.particles[p].get_color(display_mode)
		
		#uncomment for speed-based distorted water particles
		#draw_point.look_at(SPH.particles[p].velocity + draw_point.position)
		#draw_point.scale = default_scale
		#draw_point.scale.x *= 1 + SPH.particles[p].velocity.length()

func handle_input():
	$mouse.position = $View.get_mouse_position()
	if Input.is_action_just_pressed('attract'): $mouse.modulate = Color(1,1,1,1)
	if Input.is_action_pressed('attract'):
		var mouse_pos = $View.get_mouse_position() / Constants.SCALE
		SPH.attraction_force(mouse_pos, -8)
	if Input.is_action_just_released('attract'): $mouse.modulate = Color(1,1,1,0)
	
	if Input.is_action_just_released('pause'):
		paused = !paused
		$Paused.visible = paused
	
	if Input.is_action_just_released('reset'):
		SPH._init()
		$Tween.interpolate_property(self, 'paused', true, paused, 0.7, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
		$Tween.interpolate_property(self, 'i_reset', 0.0, 1.0, 0.7, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0)
		$Tween.start()
		i_reset = 0.0
	
	if Input.is_action_just_released('blobby'):
		display_mode = Constants.DRAW_MODE_BLOB
		particle_mat.blend_mode = particle_mat.BLEND_MODE_ADD
		$FluidDisplay.material.set_shader_param('blobby', true)
		$FluidDisplay.material.set_shader_param('color_ramp', preload('res://demo/gui/water_preset.tres'))
		$Panel.swap(Constants.DRAW_MODE_BLOB)
	elif Input.is_action_just_released('pressure'):
		display_mode = Constants.DRAW_MODE_PRESSURE
		particle_mat.blend_mode = particle_mat.BLEND_MODE_MIX
		$FluidDisplay.material.set_shader_param('blobby', false)
		$FluidDisplay.material.set_shader_param('color_ramp', preload('res://demo/gui/vis_pressure.tres'))
		$Panel.swap(Constants.DRAW_MODE_PRESSURE)
	elif Input.is_action_just_released('viscosity'):
		display_mode = Constants.DRAW_MODE_VISCOSITY
		particle_mat.blend_mode = particle_mat.BLEND_MODE_MIX
		$FluidDisplay.material.set_shader_param('blobby', false)
		$FluidDisplay.material.set_shader_param('color_ramp', preload('res://demo/gui/vis_viscosity.tres'))
		$Panel.swap(Constants.DRAW_MODE_VISCOSITY)

func update_fluid(delta):
	SPH.update(Constants.TIMESTEP if first_few_frames else delta, display_mode)
	
	if Engine.get_frames_drawn() == 5: first_few_frames = false

