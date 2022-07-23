extends RigidBody2D

#var healthParticles_scene = preload("res://Particles and FX/HealthParticles.tscn")
#var healthParticles = healthParticles_scene.instance()
var duration = 10

func _ready():
	#get_parent().call_deferred("add_child", healthParticles) 
	#healthParticles.global_position = global_position
	
	self.connect("body_entered", self, "health_body_entered")

func health_body_entered(body):
	#print("health taken")
	body.shotgunMode = true
	body.get_node("PowerupDuration").wait_time = duration
	body.get_node("PowerupDuration").start()
	queue_free()
	
	
	
