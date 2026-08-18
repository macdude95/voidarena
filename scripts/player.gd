extends CharacterBody2D

const SPEED = 280.0

var bullet_scene = preload("res://scenes/bullet.tscn")
var alive: bool = true

func _physics_process(_delta: float) -> void:
	if not alive:
		return

	var direction := Vector2.ZERO
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")

	if direction.length() > 1.0:
		direction = direction.normalized()

	velocity = direction * SPEED
	move_and_slide()

	# Aim toward mouse
	look_at(get_global_mouse_position())

	# Keep within arena
	var arena_radius = 340.0
	var dist = position.length()
	if dist > arena_radius - 12.0:
		position = position.normalized() * (arena_radius - 12.0)

func _unhandled_input(event: InputEvent) -> void:
	if not alive:
		return
	if event.is_action_pressed("shoot"):
		shoot()

func shoot() -> void:
	var bullet = bullet_scene.instantiate()
	bullet.global_position = $GunTip.global_position
	bullet.direction = (get_global_mouse_position() - global_position).normalized()
	bullet.rotation = bullet.direction.angle()
	get_tree().current_scene.get_node("Bullets").add_child(bullet)

func die() -> void:
	alive = false
	get_tree().current_scene.game_over()

func _draw() -> void:
	# Body - filled circle
	draw_circle(Vector2.ZERO, 12.0, Color(0.85, 0.85, 0.85))
	# Direction indicator - small dot ahead
	draw_circle(Vector2(16, 0), 4.0, Color(0.3, 0.3, 0.3))
	# Aim line
	draw_line(Vector2.ZERO, Vector2(20, 0), Color(0.3, 0.3, 0.3), 1.5)
