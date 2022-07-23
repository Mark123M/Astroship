extends Node2D

onready var player = $"/root/Game/Player"

func _ready():
	player.connect("score_changed", self, "player_score_changed")
	player.get_node("Spaceship").connect("health_changed", self, "player_health_changed")
	player.get_node("Spaceship").connect("player_death", self, "on_player_death")

func on_player_death():
	$RetryButton.visible = true
	$RetryButton.disabled = false
	$QuitButton.visible = true
	$QuitButton.disabled = false

func player_score_changed():
	$Score.text = str("Score: "+str(player.score))

func player_health_changed():
	if player.get_node("Spaceship").health <= 0:
		$Health.text = str("Health: 0")
	else:
		$Health.text = str("Health: "+str(player.get_node("Spaceship").health))
