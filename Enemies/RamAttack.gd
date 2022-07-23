extends Area2D

#some bullets don't queue_free() when they hit something, so 
#do the queue_free stuff inside the projectile itself
export var dmg = 5
export var breakable := false
export var DESPAWN_RANGE = 1000
export var SPEED = 8

onready var spaceship = $"/root/Game/Player/Spaceship"

var playerAlive := true

func _ready():
	self.connect("body_entered", self, "attack_body_entered")
	spaceship.connect("player_death", self, "on_player_death")

func on_player_death():
	playerAlive = false

func _physics_process(delta):
	self.rotation_degrees += SPEED
#	x += SPEED
#	pos = Vector2(x, 35*sin(0.03 * x))
#	pos = pos.rotated(angle)
#	global_position = pos + initial_pos
#
	#if (global_position-spaceship.global_position).length() > DESPAWN_RANGE:
	#	queue_free()

func attack_body_entered(body):
	queue_free()
