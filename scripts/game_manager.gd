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

func _input(event: InputEvent) -> void:
	if is_game_over and event.is_action_pressed("shoot"):
		restart()

func _on_enemy_timer() -> void:
	if is_game_over:
		return
	if enemies_alive < enemies_per_wave:
		spawn_enemy()

func spawn_wave() -> void:
	enemies_per_wave = 5 + (wave - 1) * 3
	enemies_alive = 0
	$HUD.set_wave(wave)
	$EnemyTimer.wait_time = max(0.3, 1.5 - (wave - 1) * 0.1)

func spawn_enemy() -> void:
	var enemy = enemy_scene.instantiate()
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
	if enemies_alive <= 0:
		wave += 1
		spawn_wave()

func game_over() -> void:
	if is_game_over:
		return
	is_game_over = true
	$EnemyTimer.stop()
	$HUD.show_game_over(score)
	$Player.visible = false
	# Clear remaining enemies
	for e in $Enemies.get_children():
		e.queue_free()

func restart() -> void:
	get_tree().reload_current_scene()
