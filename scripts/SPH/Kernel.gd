extends Reference

var Constants = preload('res://scripts/Constants.gd')

func kernel(x=Vector2()):
	var r2 = x.length_squared()
	var h2 = Constants.KERNEL_RANGE * Constants.KERNEL_RANGE
	
	if r2 < 0 || r2 > h2: return 0.0
	
	return Constants.KERNEL_CONST * pow(h2 - r2, 3)

func grad_kernel(x=Vector2()):
	var r = x.length()
	if r == 0.0: return Vector2()
	
	var t2 = x / r;
	var t3 = pow(Constants.KERNEL_RANGE - r, 2)
	
	return -Constants.GRAD_KERNEL_CONST * t2 * t3

func laplace_kernel(x=Vector2()):
	var r = x.length()
	return Constants.GRAD_KERNEL_CONST * (Constants.KERNEL_RANGE-r)
