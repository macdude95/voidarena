extends CanvasLayer

func set_score(value: int) -> void:
	$ScoreLabel.text = "SCORE: %d" % value

func set_wave(value: int) -> void:
	$WaveLabel.text = "WAVE: %d" % value

func show_game_over(final_score: int) -> void:
	$GameOverLabel.visible = true
	$GameOverLabel.text = "YOU DIED"
	$RestartHint.visible = true
	$RestartHint.text = "FINAL SCORE: %d — CLICK TO RESTART" % final_score
