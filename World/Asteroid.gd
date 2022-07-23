extends RigidBody2D



export var DESPAWN_RANGE = 4000
onready var spaceship = $"/root/Game/Player/Spaceship"
onready var audio = $"/root/Game/audio"
onready var camera = $"/root/Game/Player/Spaceship/Camera2D"


var debris_scene = preload("res://World/Debris1.tscn")
var asteroidDeathParticles_scene = preload("res://Particles and FX/AsteroidDeathParticles.tscn")
var debris1 = debris_scene.instance()
var debris2 = debris_scene.instance()
var debris3 = debris_scene.instance()
var debris4 = debris_scene.instance()
var debris5 = debris_scene.instance()
var playerAlive := true

export var asteroidSpeed = 200

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal Ballhit

# Called when the node enters the scene tree for the first time.
func _ready():
	linear_velocity.x = rand_range(-20, 20)
	linear_velocity.y = rand_range(-20, 20)
	angular_velocity = rand_range(-5, 5)
	$Hurtbox.connect("body_entered", self, "hurtbox_body_entered")
	
	
	debris1.z_index = 100
	get_parent().call_deferred("add_child", debris1)
	debris1.global_position = Vector2(-1000000, -1000000)
	get_parent().call_deferred("add_child", debris2)
	debris2.global_position = Vector2(-1000000, -1000000)
	get_parent().call_deferred("add_child", debris3)
	debris3.global_position = Vector2(-1000000, -1000000)
	get_parent().call_deferred("add_child", debris4)
	debris4.global_position = Vector2(-1000000, -1000000)
	get_parent().call_deferred("add_child", debris5)
	debris5.global_position = Vector2(-1000000, -1000000)
#	get_parent().add_child(debris2)
#	get_parent().add_child(debris3)
#	get_parent().add_child(debris4)
#	get_parent().add_child(debris5)
	spaceship.connect("player_death", self, "on_player_death")

func on_player_death():
	playerAlive = false
	
func _physics_process(delta):
	#print(debris1.global_position)
	#print(global_position)
	#asteroid despawn after 5000 pixels out of range
	if (global_position - spaceship.global_position).length() > DESPAWN_RANGE:
		queue_free()
	pass

func shoot_debris():
	randomize()
	debris1.global_position = global_position
	debris1.active = true
	debris1.linear_velocity = Vector2(rand_range(-1, 1) * asteroidSpeed, rand_range(-1, 1) * asteroidSpeed)
	debris1.angular_velocity = rand_range(-10, 10)
	
	debris2.global_position = global_position
	debris2.active = true
	debris2.get_node("Sprite").frame = 1
	debris2.linear_velocity = Vector2(rand_range(-1, 1) * asteroidSpeed, rand_range(-1, 1) * asteroidSpeed)
	debris2.angular_velocity = rand_range(-10, 10)
	
	debris3.global_position = global_position
	debris3.active = true
	debris3.get_node("Sprite").frame = 2
	debris3.linear_velocity = Vector2(rand_range(-1, 1) * asteroidSpeed, rand_range(-1, 1) * asteroidSpeed)
	debris3.angular_velocity = rand_range(-10, 10)
	
	debris4.global_position = global_position
	debris4.active = true
	debris4.get_node("Sprite").frame = 3
	debris4.linear_velocity = Vector2(rand_range(-1, 1) * asteroidSpeed, rand_range(-1, 1) * asteroidSpeed)
	debris4.angular_velocity = rand_range(-10, 10)
	
	debris5.global_position = global_position
	debris5.active = true
	debris5.get_node("Sprite").frame = 4
	debris5.linear_velocity = Vector2(rand_range(-1, 1) * asteroidSpeed, rand_range(-1, 1) * asteroidSpeed)
	debris5.angular_velocity = rand_range(-10, 10)
	pass

func hurtbox_body_entered(body):
	emit_signal("Ballhit")
	
	if body.is_in_group("weapon")&&body.breakable == true:
		body.queue_free()
	
	var asteroidDeathParticles = asteroidDeathParticles_scene.instance()
	get_parent().add_child(asteroidDeathParticles)
	asteroidDeathParticles.global_position = global_position
	asteroidDeathParticles.scale = Vector2(2, 2)
	asteroidDeathParticles.emitting = true
	
	camera.med_shake()
	shoot_debris()
	audio.play_ballHit()
	#yield($Ballhit, "finished")
	queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
