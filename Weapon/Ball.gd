extends RigidBody2D

onready var camera = get_parent().get_node("Spaceship/Camera2D")

export var MAX_SPEED = 1000
export var breakable := false
var reflectable := true

func _ready():
	#self.connect("body_entered", self,)
	pass

#cap the velocity for ball and chains
func _physics_process(delta):
	if linear_velocity.length() > MAX_SPEED:
		linear_velocity = linear_velocity.normalized()*MAX_SPEED
