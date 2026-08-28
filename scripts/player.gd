extends CharacterBody2D

const SPEED := 280.0
const ARENA_RADIUS := 340.0
const HOLD_THRESHOLD := 0.16
const AUTO_FIRE_INTERVAL := 0.095
const SHOTGUN_PELLETS := 7
const SHOTGUN_SPREAD := 0.34

var bullet_scene = preload("res://scenes/bullet.tscn")
var alive := true
var mouse_held := false
var hold_time := 0.0
var auto_fire_time := 0.0
var recoil := 0.0

func _ready() -> void:
	queue_redraw()

func _physics_process(delta: float) -> void:
	if not alive:
		return

	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * SPEED
	move_and_slide()

	look_at(get_global_mouse_position())
	position = position.limit_length(ARENA_RADIUS - 18.0)

	if mouse_held:
		hold_time += delta
		if hold_time >= HOLD_THRESHOLD:
			auto_fire_time -= delta
			if auto_fire_time <= 0.0:
				auto_fire_time = AUTO_FIRE_INTERVAL
				rapid_fire()

	recoil = move_toward(recoil, 0.0, delta * 10.0)
	queue_redraw()

func _input(event: InputEvent) -> void:
	if not alive:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			mouse_held = true
			hold_time = 0.0
			auto_fire_time = 0.0
		else:
			mouse_held = false
			if hold_time < HOLD_THRESHOLD:
				shotgun_blast()

func rapid_fire() -> void:
	fire_bullet((get_global_mouse_position() - global_position).normalized(), 1.0)

func shotgun_blast() -> void:
	var aim := (get_global_mouse_position() - global_position).normalized()
	for i in SHOTGUN_PELLETS:
		var t := float(i) / float(SHOTGUN_PELLETS - 1) - 0.5
		fire_bullet(aim.rotated(t * SHOTGUN_SPREAD), 0.75)
	get_tree().current_scene.on_player_shotgun()

func fire_bullet(direction: Vector2, bullet_scale: float) -> void:
	var bullet = bullet_scene.instantiate()
	bullet.global_position = $GunTip.global_position
	bullet.direction = direction
	bullet.scale = Vector2.ONE * bullet_scale
	bullet.rotation = direction.angle()
	get_tree().current_scene.get_node("Bullets").add_child(bullet)
	recoil = 1.0

func die() -> void:
	if not alive:
		return
	alive = false
	get_tree().current_scene.game_over()

func _draw() -> void:
	# Bright player silhouette with a directional weapon shape.
	draw_circle(Vector2.ZERO, 14.0, Color("d8d5c8"))
	draw_circle(Vector2.ZERO, 9.0, Color("8f918e"))
	draw_line(Vector2(5, 0), Vector2(23 + recoil * 3.0, 0), Color("e9c46a"), 5.0, true)
	draw_circle(Vector2(0, 0), 3.0, Color("f5e6bd"))
