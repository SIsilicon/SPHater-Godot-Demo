extends Reference

var Constants = preload('res://addons/sph_fluid/scripts/constants.gd')

var position = Vector2()
var velocity = Vector2()
var force = Vector2()

var mass = Constants.PARTICLE_MASS

var density = 0
var pressure = 0
var viscosity = 0

func _init(pos = Vector2()):
	position = pos

func get_color(draw_mode):
	var color = 1
	match draw_mode:
			Constants.DRAW_MODE_PRESSURE:
				color = pressure / 100.0
			Constants.DRAW_MODE_VISCOSITY:
				color = viscosity / 500.0

	return Color(color, color, color)
