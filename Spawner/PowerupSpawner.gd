extends Node

export var RANGE_Y = 300
export var RANGE_X = 500

var health_scene = preload("res://Consumables/Health.tscn")
var shotgun_scene = preload("res://Consumables/Shotgun.tscn")

var playerAlive := true
var active := true
onready var spaceShip = $"/root/Game/Player/Spaceship"

func _ready():
	$Timer.connect("timeout", self, "timer_timeout")
	$Timer.wait_time = 4
	spaceShip.connect("player_death", self, "on_player_death")

func spawner_start():
	$Timer.start()
	active = true

func spawner_stop():
	active = false

func on_player_death():
	playerAlive = false

func spawn_enemy():
	var health = health_scene.instance()
	health.global_position = rand_pos()
	get_parent().add_child(health)
	
	var shotgun = shotgun_scene.instance()
	shotgun.global_position = rand_pos()
	get_parent().add_child(shotgun)
	#print(enemyCurve.global_position)
	
func rand_pos():
	randomize()
	var choice = round(rand_range(0, 1))
	var posX
	var posY
	if choice == 1:
		posX = rand_range(0, spaceShip.global_position.x + RANGE_X + 30)
		posY = spaceShip.global_position.y + RANGE_Y + rand_range(0, 30)
	else:
		posX = spaceShip.global_position.x + RANGE_X + rand_range(0, 30)
		posY = rand_range(0, spaceShip.global_position.y + RANGE_Y + 30)
	
	var signX = round(rand_range(0, 1))
	if signX == 1:
		posX *= -1
	
	var signY = round(rand_range(0, 1))
	if signY == 1:
		posY *= -1
	
	return Vector2(posX, posY)

func timer_timeout():
	if active:
		spawn_enemy()
		$Timer.start()
