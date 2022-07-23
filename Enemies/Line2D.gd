extends Line2D

export var length := 150
var point

func _ready():
	set_as_toplevel(true)
	pass

func _physics_process(delta):
	
	point = get_parent().global_position
	add_point(point)
	
	if points.size()>30:
		remove_point(0)
