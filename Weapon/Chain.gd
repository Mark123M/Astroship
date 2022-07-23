extends RigidBody2D

onready var camera = get_parent().get_node("Spaceship/Camera2D")
onready var player = get_parent().get_node("Spaceship")

export var MAX_SPEED = 1000.0

func _ready():
	#self.connect("body_entered", self,)
	pass

#cap the velocity for ball and chains
func _physics_process(delta):
#	if self.name == "Chain"||self.name == "Chain2":
#		rotation_degrees = player.rotation_degrees
	
	if linear_velocity.length() > MAX_SPEED:
		linear_velocity = linear_velocity.normalized()*MAX_SPEED
