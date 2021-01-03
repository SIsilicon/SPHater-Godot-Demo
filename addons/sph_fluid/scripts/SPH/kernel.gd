extends Reference

var Constants = preload('res://addons/sph_fluid/scripts/constants.gd')

var kernel_range
var grad_kernel_range

func _init():
	kernel_range = 1.25 * Constants.PARTICLE_SPACING
	grad_kernel_range = 45.0 / (PI * pow(kernel_range, 6))


func kernel(x=Vector2()):
	var r2 = x.length_squared()
	var h2 = kernel_range * kernel_range

	if r2 < 0 || r2 > h2: return 0.0

	return kernel_function() * pow(h2 - r2, 3)

func grad_kernel(x=Vector2()):
	var r = x.length()
	if r == 0.0: return Vector2()

	var t2 = x / r;
	var t3 = pow(kernel_range - r, 2)

	return -grad_kernel_range * t2 * t3

func laplace_kernel(x=Vector2()):
	var r = x.length()
	return grad_kernel_range * (kernel_range-r)

func kernel_function():
	return 315.0 / (64.0 * 3 * pow(kernel_range, 9))

