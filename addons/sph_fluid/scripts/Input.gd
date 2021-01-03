extends Node

var Constants = preload('res://addons/sph_fluid/scripts/Constants.gd')
# var SPH = preload('res://scripts/SPH/Solver.gd').new()

var i_reset = 1.0
var display_mode = Constants.DRAW_MODE_BLOB
var particle_mat = CanvasItemMaterial.new()
var first_few_frames = true
var paused = false

onready var label_paused = get_node('../../Paused')
onready var tween = get_node('../../Tween')
onready var fluid_display = get_node('../FluidDisplay')
onready var panel = get_node('../../Panel')
onready var parent = get_parent()

func _ready():	
	$mouse.scale /= 32.0
	$mouse.scale *= 3 * Constants.KERNEL_RANGE * Constants.SCALE

func _physics_process(delta):
	handle_input()

func handle_input():
	#$mouse.position = view.get_mouse_position()
	if Input.is_action_just_pressed('attract'): $mouse.modulate = Color(1,1,1,1)
	if Input.is_action_pressed('attract'):
		pass
		#var mouse_pos = view.get_mouse_position() / Constants.SCALE
		#parent.SPH.attraction_force(mouse_pos, -8)
	if Input.is_action_just_released('attract'): $mouse.modulate = Color(1,1,1,0)
	
	if Input.is_action_just_released('pause'):
		pass
		#parent.paused = !parent.paused
		#paused = !paused
		#label_paused.visible = parent.paused
	
	if Input.is_action_just_released('reset'):
		#SPH._init()
		#$Tween.interpolate_property(self, 'paused', true, paused, 0.7, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
		#$Tween.interpolate_property(self, 'i_reset', 0.0, 1.0, 0.7, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0)
		#$Tween.start()
		i_reset = 0.0
	
	if Input.is_action_just_released('blobby'):
		display_mode = Constants.DRAW_MODE_BLOB
		particle_mat.blend_mode = particle_mat.BLEND_MODE_ADD
		fluid_display.material.set_shader_param('blobby', true)
		fluid_display.material.set_shader_param('color_ramp', preload('res://demo/gui/water_preset.tres'))
		panel.swap(Constants.DRAW_MODE_BLOB)
	# elif Input.is_action_just_released('pressure'):
	# 	display_mode = Constants.DRAW_MODE_PRESSURE
	# 	particle_mat.blend_mode = particle_mat.BLEND_MODE_MIX
	# 	$FluidDisplay.material.set_shader_param('blobby', false)
	# 	$FluidDisplay.material.set_shader_param('color_ramp', preload('res://demo/gui/vis_pressure.tres'))
	# 	$Panel.swap(Constants.DRAW_MODE_PRESSURE)
	# elif Input.is_action_just_released('viscosity'):
	# 	display_mode = Constants.DRAW_MODE_VISCOSITY
	# 	particle_mat.blend_mode = particle_mat.BLEND_MODE_MIX
	# 	$FluidDisplay.material.set_shader_param('blobby', false)
	# 	$FluidDisplay.material.set_shader_param('color_ramp', preload('res://demo/gui/vis_viscosity.tres'))
	# 	$Panel.swap(Constants.DRAW_MODE_VISCOSITY)
