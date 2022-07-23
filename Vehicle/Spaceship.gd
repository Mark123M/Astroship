extends KinematicBody2D

export var ACCEL = 350
export var FRICTION = 300
export var MAX_SPEED = 250
export var health = 20
export var MAX_HEALTH = 20

export var ANGULAR_ACCEL = 5
export var MAX_ANGULAR_SPEED = 4

var velocity = Vector2.ZERO
#var angularVelocity = Vector2.ZERO
var spinningSoundPlayed := false
var laser_scene = preload("res://Weapon/Laser.tscn")
var shells_scene = preload("res://Weapon/Shells.tscn")
var playerDeathParticles_scene = preload("res://Particles and FX/PlayerDeathParticles.tscn")
var weaponReady := true
var dashReady := true
var dashDir : Vector2
var dashVel : Vector2
var playerDeathParticles = playerDeathParticles_scene.instance()

var shotgunMode := false

var playerAlive = true

var state

enum{
	MOVE,
	DASH
}
#var dashed := false

#225.25
onready var MAX_DIST_FROM_BALL = 225.25 * get_parent().scale.x
onready var ball = get_parent().get_node("Ball")
onready var DIST_FROM_BALL = (self.global_position - ball.global_position).length()
onready var audio = $"/root/Game/audio"


signal player_death
signal health_changed

func _ready():
	
	state = MOVE
	
	$Hurtbox.connect("area_entered", self, "hurtbox_area_entered")
	$WeaponCooldown.connect("timeout", self, "weaponCooldown_timeout")
	$DashCooldown.connect("timeout", self, "dashCooldown_timeout")
	$DashDuration.connect("timeout", self, "dashDuration_timeout")
	$PowerupDuration.connect("timeout", self, "powerupDuration_timeout")
	$"/root/Game".call_deferred("add_child", playerDeathParticles)
	pass 

func powerupDuration_timeout():
	shotgunMode = false

func _physics_process(delta):
	#var look = global_position.direction_to(get_global_mouse_position())
	if playerAlive:
		look_at(get_global_mouse_position())
		rotation_degrees += 90
		
		if state == MOVE:
			move_state(delta)
		elif state == DASH:
			dash_state(delta)

func dashDuration_timeout():
	#velocity = move_and_slide(Vector2.ZERO)
	state = MOVE
	pass

func dash_state(delta):
	dashVel = move_and_slide(dashVel)
	dashVel = dashVel.move_toward(Vector2.ZERO, 200*delta)
	pass

func move_state(delta):
	
	#if too close, the ship temperature rises and the ship dies if too hot
	#cus its using a meteor
	#implement the temp increase later
	#if DIST_FROM_BALL<50:
	#	var weapons = get_tree().get_nodes_in_group("weapon")
	#	for weapon in weapons:
	#		weapon.queue_free()
	#	queue_free()
	#	emit_signal("player_death")
		
	#if swung too hard, the ball would move the ship
	DIST_FROM_BALL = (self.global_position - ball.global_position).length()
#	if DIST_FROM_BALL > MAX_DIST_FROM_BALL:
#		velocity = velocity.move_toward(global_position.direction_to(ball.global_position) * 300, 500*delta)
#		velocity = move_and_slide(velocity)
	#print(ball.position)
	
	#when ball is far, slow it down more so it doesnt bounce up to the ship
	if DIST_FROM_BALL > 100:
		ball.linear_damp = 1
	else:
		ball.linear_damp = 0.5
	
	var vector := Vector2.ZERO
	#var angularVector := Vector2.ZERO
	#get the net vector of the input
	vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	#vector = vector.rotated(deg2rad(self.rotation_degrees))
	vector = vector.normalized()
	
#	angularVector.x = Input.get_action_strength("rotate_right") - Input.get_action_strength("rotate_left")
	
	if vector != Vector2.ZERO:
		velocity = velocity.move_toward(vector * MAX_SPEED, ACCEL*delta)	
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION*delta)
	
	velocity = move_and_slide(velocity)
	
#	if angularVector != Vector2.ZERO:
#		if !spinningSoundPlayed:
#			spinningSoundPlayed = true
#			audio.play_spinningSound()
#		angularVelocity = angularVelocity.move_toward(angularVector*MAX_ANGULAR_SPEED, ANGULAR_ACCEL*delta)
#	else:
#		spinningSoundPlayed = false
#		audio.stop_spinningSound()
#		angularVelocity = angularVelocity.move_toward(Vector2.ZERO, ANGULAR_ACCEL*delta)
	if Input.is_action_just_pressed("dash") && dashReady:
		state = DASH
		dashDir = global_position.direction_to(get_global_mouse_position())
		dashReady = false
		dashVel = dashDir* 1000
		$DashCooldown.start()
		$DashDuration.start()
		
	if Input.is_action_just_pressed("shoot") && weaponReady:
		if shotgunMode:
			shoot_shells()
			weaponReady = false
			$WeaponCooldown.start()
		else:
			shoot_laser()
			weaponReady = false
			$WeaponCooldown.start()
		
	
	#self.rotation_degrees += angularVelocity.x

func shoot_shells():
	var shell1 = shells_scene.instance()
	var shell2 = shells_scene.instance()
	var shell3 = shells_scene.instance()
	var shell4 = shells_scene.instance()
	
	$"/root/Game".add_child(shell1)
	$"/root/Game".add_child(shell2)
	$"/root/Game".add_child(shell3)
	$"/root/Game".add_child(shell4)
	
	shell1.global_position = global_position
	shell2.global_position = global_position
	shell3.global_position = global_position
	shell4.global_position = global_position
	
	shell1.rotation_degrees = rotation_degrees + 22.5
	shell2.rotation_degrees = rotation_degrees + 7.5
	shell3.rotation_degrees = rotation_degrees - 7.5
	shell4.rotation_degrees = rotation_degrees - 22.5
	
	var dir1 = Vector2(0, -1).rotated(deg2rad(rotation_degrees+22.5)).normalized()
	var dir2 = Vector2(0, -1).rotated(deg2rad(rotation_degrees+7.5)).normalized()
	var dir3 = Vector2(0, -1).rotated(deg2rad(rotation_degrees-7.5)).normalized()
	var dir4 = Vector2(0, -1).rotated(deg2rad(rotation_degrees-22.5)).normalized()
	
	shell1.velocity = dir1*600
	shell2.velocity = dir2*600
	shell3.velocity = dir3*600
	shell4.velocity = dir4*600

func shoot_laser():
	var laser = laser_scene.instance()
	$"/root/Game".add_child(laser)
	laser.global_position = global_position
	laser.rotation_degrees = rotation_degrees
	var dir = Vector2(0, -1).rotated(deg2rad(rotation_degrees)).normalized()
	laser.velocity = dir * 600

func weaponCooldown_timeout():
	weaponReady = true

func dashCooldown_timeout():
	dashReady = true
	
func hurtbox_area_entered(area):
	health = health - area.dmg
	if area.is_in_group("EnemyAttack") && area.breakable:
		area.queue_free()
	emit_signal("health_changed")
	#print(health)
	
	if health<=0 && playerAlive:
		$"/root/Game/BasicEnemySpawner".spawner_stop()
		$"/root/Game/EnemySpreadSpawner".spawner_stop()
		$"/root/Game/EnemyCurveSpawner".spawner_stop()
		$"/root/Game/EnemyRammerSpawner".spawner_stop()
		$"/root/Game/AsteroidSpawner".spawner_stop()
		$"/root/Game/PowerupSpawner".spawner_stop()
		
		$"/root/Game/CanvasLayer/Title".visible = true
		$"/root/Game/CanvasLayer/GUI/Health".visible = false
		$"/root/Game/CanvasLayer/GUI/Score".visible = false
		
		playerAlive = false
		$Camera2D.current = false
		
		emit_signal("player_death")
		playerDeathParticles.scale = Vector2(2, 2)
		playerDeathParticles.global_position = global_position
		playerDeathParticles.emitting = true
		
		#$"/root/Game/Player/PinJoint2D".node_a = "/root/Game/Player/Chain"
		global_position = Vector2(global_position.x - 1000, global_position.y - 1000)
		visible = false
	pass

#func pause_game():
	

