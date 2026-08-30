extends Area2D

@export var speed: float = 100.0
var target: Node2D = null
var enemy_type: int = 0
var phase := 0.0
var rusher_state := 0 # 0: stalking, 1: telegraphing, 2: charging
var rusher_timer := 0.0
var rusher_heading := Vector2.ZERO
var orbit_direction := 1.0
var orbit_radius := 0.0

func _ready() -> void:
	add_to_group("enemy")
	body_entered.connect(_on_body_entered)
	phase = randf() * TAU
	orbit_direction = -1.0 if randf() < 0.5 else 1.0
	orbit_radius = global_position.length()
	queue_redraw()

func _physics_process(delta: float) -> void:
	if not target or not is_instance_valid(target):
		return

	var to_target := target.global_position - global_position
	var direction := to_target.normalized()

	match enemy_type:
		1:
			_process_rusher(delta, direction)
		2:
			_process_wraith(delta, direction)
		_:
			# Crawler: simple, relentless pursuit. It is the baseline threat.
			position += direction * speed * delta

	rotation = direction.angle()
	queue_redraw()

func _process_rusher(delta: float, direction: Vector2) -> void:
	# Rushers alternate between stalking, a visible telegraph, and a committed dash.
	rusher_timer -= delta
	if rusher_state == 0:
		position += direction * speed * 0.62 * delta
		if rusher_timer <= 0.0:
			rusher_state = 1
			rusher_timer = 0.82
			# Lock the attack vector when the warning begins. The player can dodge it,
			# but the Rusher will not correct its trajectory during the warning.
			rusher_heading = direction
	elif rusher_state == 1:
		# Slow down while telegraphing; the pulsing body warns the player.
		position += direction * speed * 0.12 * delta
		if rusher_timer <= 0.0:
			rusher_state = 2
			rusher_timer = 0.34
	else:
		position += rusher_heading * speed * 3.2 * delta
		if rusher_timer <= 0.0:
			rusher_state = 0
			rusher_timer = randf_range(0.7, 1.5)

func _process_wraith(delta: float, direction: Vector2) -> void:
	# Wraiths orbit the player, switching sides periodically instead of homing.
	phase += delta * 2.5
	if fmod(phase, TAU) > 5.7 and fmod(phase, TAU) < 5.7 + delta * 2.5:
		orbit_direction *= -1.0
	var tangent := direction.orthogonal() * orbit_direction
	var closing_force := direction * 0.42
	var orbit_force := tangent * (0.95 + sin(phase * 0.7) * 0.2)
	position += (closing_force + orbit_force).normalized() * speed * delta

func die() -> void:
	var gm = get_tree().current_scene
	if gm.has_method("on_enemy_killed"):
		gm.on_enemy_killed()
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and body.has_method("die"):
		body.die()

func _draw() -> void:
	if enemy_type == 1:
		var telegraph_color := Color("ffb15c") if rusher_state == 1 else Color("ed564c")
		var points := PackedVector2Array([Vector2(15, 0), Vector2(-8, -10), Vector2(-3, 0), Vector2(-8, 10)])
		draw_colored_polygon(points, telegraph_color)
		draw_polyline(points + PackedVector2Array([points[0]]), Color("7c231f"), 2.0)
		if rusher_state == 1:
			draw_arc(Vector2.ZERO, 17.0 + sin(rusher_timer * 20.0) * 2.0, 0.0, TAU, 24, Color(1.0, 0.65, 0.25, 0.8), 2.0)
	elif enemy_type == 2:
		var points := PackedVector2Array([Vector2(0, -13), Vector2(11, 0), Vector2(0, 13), Vector2(-11, 0)])
		draw_colored_polygon(points, Color("b79aa8"))
		draw_circle(Vector2.ZERO, 4.0, Color("342530"))
		draw_polyline(points + PackedVector2Array([points[0]]), Color("694c5b"), 1.5)
	else:
		var points := PackedVector2Array([Vector2(0, -10), Vector2(10, 0), Vector2(0, 10), Vector2(-10, 0)])
		draw_colored_polygon(points, Color("b93232"))
		draw_polyline(points + PackedVector2Array([points[0]]), Color("5f1717"), 1.5)
