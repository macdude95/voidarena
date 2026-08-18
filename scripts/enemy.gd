extends Area2D

@export var speed: float = 100.0
var target: Node2D = null

func _ready() -> void:
	add_to_group("enemy")
	body_entered.connect(_on_body_entered)
	queue_redraw()

func _physics_process(delta: float) -> void:
	if target and is_instance_valid(target):
		var direction = (target.global_position - global_position).normalized()
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
	# Red diamond shape
	var points = PackedVector2Array([
		Vector2(0, -10),
		Vector2(10, 0),
		Vector2(0, 10),
		Vector2(-10, 0),
	])
	draw_colored_polygon(points, Color(0.85, 0.15, 0.15))
	draw_polyline(points + PackedVector2Array([Vector2(0, -10)]), Color(0.4, 0.05, 0.05), 1.5)
