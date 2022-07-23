extends RigidBody2D

signal explode
signal score_changed

var is_exploded := false
var rng := RandomNumberGenerator.new()

var score_value = 100

var explosion_pitch = 1
#cant preload because the loading would happen DURING when the scene plays
#because AsteroidSmall inherits this script also
var asteroidsmall_scene := load("res://objects/AsteroidSmall.tscn")
#var explosion_particles_scene := load("res://objects/ParticlesAsteroidExplosion.tscn")
#var points_scored_scene := load("res://ui/PointsScored.tscn")

#connect signals using code this time
func _ready():
	
	pass
	#var main_camera = get_node("/root/Game/MainCamera")
	#self.connect("explode", main_camera, "asteroid_exploded")
	#var label = get_tree().get_root().get_node("Game/GUI/MarginContainer/HBoxContainer/VBoxContainer/Score")
	#self.connect("score_changed", label, "update_score")

func explode():
	
	#makes sure function is only called once if lets say 2 lasers hit an asteroid
	if is_exploded:
		return;
	
	is_exploded = true;
	
	#_explosion_particles()
	#_play_explosion_sound()
	
	emit_signal("explode")
	
	emit_signal("score_changed", score_value)
	
#	_spawn_score()
	
	_spawn_debris(4)
	
	#ERROR: _set_color: Condition "p_node == _data._nil && p_color == RED" is true.
  # At: ./core/map.h:154
	#i kept getting this error after crashing and fixed it by deleting the removechild
	
	#get_parent().remove_child(self)
	queue_free()
	

#func _spawn_score():
#	var points_scored = points_scored_scene.instance()
#	points_scored.get_node("Label").text = str(score_value)
#	points_scored.position = self.position
#	get_parent().add_child(points_scored)
	
#func _play_explosion_sound():
#	var explosion_sound = AudioStreamPlayer2D.new()
#	explosion_sound.stream = load("res://assets/audio/sfx/AsteroidExplosion.wav")
#	explosion_sound.pitch_scale = explosion_pitch
#	explosion_sound.position = self.position
	#add as a child of asteroid's parent so that it stays in the scene_tree
	#even after asteroid explodes and queue_free() calls
#	get_parent().add_child(explosion_sound)
#	explosion_sound.play(0)

#func _explosion_particles():
#	var explosion_particles = explosion_particles_scene.instance()
#	explosion_particles.position = self.position
	#add as a child of asteroid's parent so that it stays in the scene_tree
	#even after asteroid explodes and queue_free() calls
#	get_parent().add_child(explosion_particles)
#	explosion_particles.emitting = true

func _spawn_debris(num: int) -> void:
	for i in range(num):
		_spawn_asteroidsmall()

func _spawn_asteroidsmall():
	var asteroid_small = asteroidsmall_scene.instance()
	asteroid_small.position = self.position #spawns from the asteroid
	_rand_trajectory(asteroid_small)
	get_parent().add_child(asteroid_small)
	
	
func _rand_trajectory(asteroid):
	#random spin for debris
	randomize()
	asteroid.angular_velocity = rand_range(-4, 4)
	asteroid.angular_damp = 0
	
	#generates random int from -1 to 1
	rng.randomize()
	var lv_x = rng.randi_range(-1, 1)
	var lv_y = rng.randi_range(-1, 1)
	
	#random direction
	asteroid.linear_velocity = Vector2(lv_x*400, lv_y*400)
	asteroid.linear_damp = 0

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	queue_free()
