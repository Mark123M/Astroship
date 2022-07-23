extends RigidBody2D

export var DESPAWN_RANGE = 2000
var active := false
onready var spaceship = $"/root/Game/Player/Spaceship"
onready var audio = $"/root/Game/audio"
onready var camera = $"/root/Game/Player/Spaceship/Camera2D"
var asteroidDeathParticles_scene = preload("res://Particles and FX/AsteroidDeathParticles.tscn")
var playerAlive = true

signal Ballhit

func _ready():
	$Hurtbox.connect("body_entered", self, "hurtbox_body_entered")
	spaceship.connect("player_death", self, "on_player_death")

func on_player_death():
	playerAlive = false

func _physics_process(delta):
	if active && (global_position - spaceship.global_position).length()>DESPAWN_RANGE:
		queue_free()

func hurtbox_body_entered(body):
	camera.small_shake()
	emit_signal("Ballhit")
	
	if body.is_in_group("weapon")&&body.breakable == true:
		body.queue_free()
	
	var asteroidDeathParticles = asteroidDeathParticles_scene.instance()
	get_parent().add_child(asteroidDeathParticles)
	asteroidDeathParticles.global_position = global_position
	asteroidDeathParticles.emitting = true
	
	audio.play_ballHit()
#	yield($Ballhit, "finished")
	
	queue_free()
