extends RigidBody2D


var duration = 10

func _ready():
	self.connect("body_entered", self, "reflect_body_entered")

func reflect_body_entered(body):
	var ball = body.get_parent().get_node("Ball")

