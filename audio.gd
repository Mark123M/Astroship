extends Node

var ballHit_scene = preload("res://Audio/Ballhit.tscn")
var basicAttackSound_scene = preload("res://Audio/BasicAttackSound.tscn")
var spinningSound_scene = preload("res://Audio/SpinningSound.tscn")
var spinningSound = spinningSound_scene.instance()

func play_ballHit():
	var ballHit = ballHit_scene.instance()
	get_parent().add_child(ballHit)
	ballHit.play()

func play_basicAttackSound():
	var basicAttackSound = basicAttackSound_scene.instance()
	get_parent().add_child(basicAttackSound)
	basicAttackSound.play()

func play_spinningSound():
	
	get_parent().add_child(spinningSound)
	spinningSound.play()

func stop_spinningSound():
	spinningSound.stop()
#func stop_spinningSound():
	
