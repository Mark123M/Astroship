extends KinematicBody2D

export var DESPAWN_RANGE = 2000

var velocity
export var breakable := true
onready var spaceship = $"/root/Game/Player/Spaceship"

func _physics_process(delta):
	move_and_slide(velocity)
	if (global_position - spaceship.global_position).length()>DESPAWN_RANGE:
		queue_free()
