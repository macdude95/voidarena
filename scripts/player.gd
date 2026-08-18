extends CharacterBody2D

const SPEED = 280.0

var bullet_scene = preload("res://scenes/bullet.tscn")

func _physics_process(_delta: float) -> void:
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
	if event.is_action_pressed("shoot"):
		shoot()

func shoot() -> void:
	var bullet = bullet_scene.instantiate()
	bullet.position = $GunTip.global_position
	bullet.direction = (get_global_mouse_position() - global_position).normalized()
	bullet.rotation = bullet.direction.angle()
	get_tree().current_scene.get_node("Bullets").add_child(bullet)

func die() -> void:
	get_tree().current_scene.game_over()
