extends Node2D

onready var spaceship = $"Player/Spaceship"
onready var retryButton = $"CanvasLayer/GUI/RetryButton"
onready var quitButton = $"CanvasLayer/GUI/QuitButton"
onready var title = $"CanvasLayer/Title"
onready var text = $"CanvasLayer/Text"
onready var health = $"CanvasLayer/GUI/Health"
onready var score = $"CanvasLayer/GUI/Score"

func _ready():
	retryButton.connect("pressed", self, "retryButton_pressed")
	quitButton.connect("pressed", self, "quitButton_pressed")
	pass 

func quitButton_pressed():
	get_tree().quit()

func retryButton_pressed():
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.queue_free()
	for object in get_tree().get_nodes_in_group("world"):
		object.queue_free()
	start_game()

func start_game():
	retryButton.visible = false
	retryButton.disabled = true
	quitButton.visible = false
	quitButton.disabled = true
	title.visible = false
	text.visible = false
	
	health.visible = true
	score.visible = true
	
	spaceship.health = spaceship.MAX_HEALTH
	spaceship.emit_signal("health_changed")
	
	$Player.score = 0
	$Player.emit_signal("score_changed")
	
	spaceship.visible = true
	spaceship.global_position = Vector2(0, 0)
	$"/root/Game/Player/Chain".global_position = Vector2(0, 22)
	spaceship.playerAlive = true
	spaceship.get_node("Camera2D").current = true
	
	#$"/root/Game/Player/Chain".global_position = Vector2(0, 21.526)
	#$"/root/Game/Player/PinJoint2D".node_a = spaceship.get_path()
	$BasicEnemySpawner.spawner_start()
	$EnemySpreadSpawner.spawner_start()
	$EnemyCurveSpawner.spawner_start()
	$EnemyRammerSpawner.spawner_start()
	$AsteroidSpawner.spawner_start()
	
	$PowerupSpawner.spawner_start()
	
	
	#spaceship.
	$Player.score = 0
	pass
