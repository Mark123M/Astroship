extends RigidBody2D

var healthParticles_scene = preload("res://Particles and FX/HealthParticles.tscn")
var healthParticles = healthParticles_scene.instance()

func _ready():
	get_parent().call_deferred("add_child", healthParticles) 
	healthParticles.global_position = global_position
	
	self.connect("body_entered", self, "health_body_entered")

func health_body_entered(body):
	#print("health taken")
	if body.health < body.MAX_HEALTH:
		body.health += 5
		body.emit_signal("health_changed")
		
		#caps health to max health
		if body.health > body.MAX_HEALTH:
			body.health = body.MAX_HEALTH
			body.emit_signal("health_changed")
		
		healthParticles.emitting = true
		queue_free()
		
		
	
