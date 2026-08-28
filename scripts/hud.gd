extends CanvasLayer

func set_score(value: int) -> void:
	$ScoreLabel.text = "SCORE  %04d" % value

func set_wave(value: int) -> void:
	$WaveLabel.text = "DEPTH  %02d" % value

func set_weapon_hint(value: String) -> void:
	$WeaponLabel.text = value

func show_game_over(final_score: int) -> void:
	$GameOverLabel.visible = true
	$GameOverLabel.text = "SIGNAL LOST"
	$RestartHint.visible = true
	$RestartHint.text = "SCORE %04d   //   CLICK TO RE-ENTER" % final_score
