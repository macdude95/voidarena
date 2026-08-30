extends Node2D

const RADIUS := 520.0

func _ready() -> void:
	queue_redraw()

func _draw() -> void:
	# A clean, restrained arena boundary plus subtle inner rings for depth.
	draw_arc(Vector2.ZERO, RADIUS, 0.0, TAU, 128, Color(0.48, 0.39, 0.2, 0.72), 2.0, true)
	draw_arc(Vector2.ZERO, RADIUS - 8.0, 0.0, TAU, 128, Color(0.24, 0.22, 0.17, 0.55), 1.0, true)
	draw_arc(Vector2.ZERO, RADIUS * 0.56, 0.0, TAU, 96, Color(0.22, 0.19, 0.14, 0.18), 1.0, true)
	for angle in range(0, 360, 45):
		var direction := Vector2.from_angle(deg_to_rad(float(angle)))
		draw_line(direction * (RADIUS - 16.0), direction * (RADIUS - 6.0), Color(0.78, 0.62, 0.3, 0.7), 2.0)
