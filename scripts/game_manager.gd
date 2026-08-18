extends Node2D

var score: int = 0
var wave: int = 1
var enemies_alive: int = 0
var enemies_per_wave: int = 5
var is_game_over: bool = false

var enemy_scene = preload("res://scenes/enemy.tscn")
var arena_radius: float = 340.0

func _ready() -> void:
	$EnemyTimer.timeout.connect(_on_enemy_timer)
	$HUD.set_score(0)
	$HUD.set_wave(1)
	spawn_wave()

func _on_enemy_timer() -> void:
	if is_game_over:
		return
	if enemies_alive < enemies_per_wave:
		spawn_enemy()

func spawn_wave() -> void:
	enemies_per_wave = 5 + (wave - 1) * 3  # 5, 8, 11, 14...
	enemies_alive = 0
	$HUD.set_wave(wave)
	# Increase spawn rate over waves
	$EnemyTimer.wait_time = max(0.3, 1.5 - (wave - 1) * 0.1)

func spawn_enemy() -> void:
	var enemy = enemy_scene.instantiate()
	# Random position on arena edge
	var angle = randf() * TAU
	var spawn_pos = Vector2.from_angle(angle) * (arena_radius - 30.0)
	enemy.position = spawn_pos
	enemy.speed = 80.0 + randf_range(0, 40.0 + wave * 10.0)
	enemy.target = $Player
	$Enemies.add_child(enemy)
	enemies_alive += 1

func on_enemy_killed() -> void:
	score += 1
	enemies_alive -= 1
	$HUD.set_score(score)
	# Advance wave when all enemies killed
	if enemies_alive <= 0:
		wave += 1
		spawn_wave()

func game_over() -> void:
	if is_game_over:
		return
	is_game_over = true
	$EnemyTimer.stop()
	$HUD.show_game_over(score)
	# Hide player
	$Player.visible = false
	$Player.set_physics_process(false)
	# Clear remaining enemies
	for e in $Enemies.get_children():
		e.queue_free()
	# Wait for click to restart
	await get_tree().create_timer(1.0).timeout
	# Poll for input to restart
	while is_game_over:
		if Input.is_action_just_pressed("shoot"):
			restart()
		await get_tree().process_frame

func restart() -> void:
	get_tree().reload_current_scene()
