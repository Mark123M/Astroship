extends KinematicBody2D

#this enemy has to stop to attack

#add an inactive/wander state later for stealth stuff i guess or if the enemy is out of player range detection
enum{
	MOVE,
	ATTACK
}

var state
var basicAttack_scene = preload("res://Enemies/BasicAttack.tscn")
var enemyDeathParticles_scene = preload("res://Particles and FX/EnemyDeathParticles.tscn")
var attacked := false

export var MAX_SPEED = 200
export var ACCEL = 100
export var ATTACK_RANGE = 180
export var SCORE = 150

var velocity = Vector2.ZERO
var playerAlive := true

onready var spaceship = $"/root/Game/Player/Spaceship"
onready var timer = $AttackTimer
onready var deathDelay = $DeathDelay
onready var audio = $"/root/Game/audio"
onready var camera = $"/root/Game/Player/Spaceship/Camera2D"

signal Ballhit

func _ready():
	$Hurtbox.connect("body_entered", self, "hurtbox_body_entered")
	state = MOVE
	spaceship.connect("player_death", self, "on_player_death")

func on_player_death():
	playerAlive = false

func _physics_process(delta):
	look_at(spaceship.global_position)
	if state == MOVE:
		move_state(delta)
	elif state == ATTACK:
		attack()

func move_state(delta):
	var dir = global_position.direction_to(spaceship.global_position)
	velocity = velocity.move_toward(dir*MAX_SPEED, ACCEL*delta)
	velocity = move_and_slide(velocity)
	if (global_position - spaceship.global_position).length() <= ATTACK_RANGE:
		state = ATTACK
			
#the reason why my timer was always at 1 was because i kept on starting it lmao
#made function oneshot
func attack():
	if !attacked:
		attacked = true
		
		timer.wait_time = 0.7
		timer.start()
		yield(timer, "timeout")
		
		var dirToPlayer = global_position.direction_to(spaceship.global_position)
		
		#velocity = move_and_slide(-1*dirToPlayer*800)
		
		var basicAttack = basicAttack_scene.instance()
		var basicAttack2 = basicAttack_scene.instance()
		var basicAttack3 = basicAttack_scene.instance()
		
		basicAttack.global_position = self.global_position
		basicAttack2.global_position = self.global_position
		basicAttack3.global_position = self.global_position
		
		
		basicAttack.velocity = dirToPlayer * basicAttack.SPEED
		basicAttack2.velocity = dirToPlayer.rotated(PI/16) * basicAttack.SPEED
		basicAttack3.velocity = dirToPlayer.rotated(-PI/16) * basicAttack.SPEED
		get_parent().add_child(basicAttack)
		get_parent().add_child(basicAttack2)
		get_parent().add_child(basicAttack3)
		audio.play_basicAttackSound()
		
		
		timer.wait_time = 2
		timer.start()
		yield(timer, "timeout")
		
		
		attacked = false
		velocity = Vector2.ZERO
		state = MOVE

func hurtbox_body_entered(body):
	
	camera.small_shake()
	emit_signal("Ballhit")
	
	if body.is_in_group("weapon")&&body.breakable == true:
		body.queue_free()
	
	spaceship.get_parent().score += SCORE
	spaceship.get_parent().emit_signal("score_changed")
	
	var enemyDeathParticles = enemyDeathParticles_scene.instance()
	get_parent().add_child(enemyDeathParticles)
	enemyDeathParticles.global_position = global_position
	enemyDeathParticles.scale = Vector2(1.2 ,1.2)
	enemyDeathParticles.emitting = true
	
	audio.play_ballHit()
	#yield($Ballhit, "finished")

#	deathDelay.wait_time = 0.4
#	deathDelay.start()
#	var velocity = body.linear_velocity
#	velocity = move_and_slide(velocity)
#
#
#	yield(deathDelay, "timeout")
	queue_free()

