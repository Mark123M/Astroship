extends Camera2D


func small_shake() -> void:
	$ScreenShake.start(0.5, 20, 5, 0)

func med_shake() ->void:
	$ScreenShake.start(0.5, 20, 10, 0)
