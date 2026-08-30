extends Area2D

@export var speed: float = 100.0
var target: Node2D = null
var enemy_type: int = 0
var phase := 0.0

func _ready() -> void:
	add_to_group("enemy")
	body_entered.connect(_on_body_entered)
	phase = randf() * TAU
	queue_redraw()

func _physics_process(delta: float) -> void:
	if target and is_instance_valid(target):
		var to_target := target.global_position - global_position
		var direction := to_target.normalized()
		if enemy_type == 1:
			# Rusher: commits hard to a fast, direct line.
			position += direction * speed * delta
		elif enemy_type == 2:
			# Wraith: strafes around its approach vector, making aim less predictable.
			phase += delta * 3.0
			var side := direction.orthogonal() * sin(phase) * 0.72
			position += (direction + side).normalized() * speed * delta
		else:
			position += direction * speed * delta
		rotation = direction.angle()

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
		# Rusher: sharp crimson arrowhead.
		var points := PackedVector2Array([Vector2(13, 0), Vector2(-7, -9), Vector2(-3, 0), Vector2(-7, 9)])
		draw_colored_polygon(points, Color("ed564c"))
		draw_polyline(points + PackedVector2Array([points[0]]), Color("7c231f"), 2.0)
	elif enemy_type == 2:
		# Wraith: pale diamond with a dark core.
		var points := PackedVector2Array([Vector2(0, -13), Vector2(11, 0), Vector2(0, 13), Vector2(-11, 0)])
		draw_colored_polygon(points, Color("b79aa8"))
		draw_circle(Vector2.ZERO, 4.0, Color("342530"))
		draw_polyline(points + PackedVector2Array([points[0]]), Color("694c5b"), 1.5)
	else:
		# Crawler: the baseline red diamond.
		var points := PackedVector2Array([Vector2(0, -10), Vector2(10, 0), Vector2(0, 10), Vector2(-10, 0)])
		draw_colored_polygon(points, Color("b93232"))
		draw_polyline(points + PackedVector2Array([points[0]]), Color("5f1717"), 1.5)
