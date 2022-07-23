extends Area2D

#some bullets don't queue_free() when they hit something, so 
#do the queue_free stuff inside the projectile itself
export var dmg = 2
export var breakable := true
export var DESPAWN_RANGE = 1000
export var SPEED = 2

onready var spaceship = $"/root/Game/Player/Spaceship"

var velocity = Vector2.ZERO
var playerAlive := true

func _ready():
	self.connect("body_entered", self, "attack_body_entered")
	spaceship.connect("player_death", self, "on_player_death")

func on_player_death():
	playerAlive = false

func _physics_process(delta):
	global_position += velocity
	
	if (global_position-spaceship.global_position).length() > DESPAWN_RANGE:
		queue_free()

func attack_body_entered(body):
	if body.name == "Ball" && body.reflectable:
		velocity = -velocity
		self.collision_mask = 0b00000000000000010100
		
	else: 
		queue_free()
