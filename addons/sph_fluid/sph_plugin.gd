tool
extends EditorPlugin


func _enter_tree():
	#scene = preload("res://addons/sph_fluid/Liquid.tscn").instance()

	add_custom_type("SPHFluid", "Node2D", preload("scripts/Main.gd"), preload("icon.png"))
	pass


func _exit_tree():
	remove_custom_type("SPHFluid")
	pass
