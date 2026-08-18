extends Area2D

var direction: Vector2 = Vector2.RIGHT
const BULLET_SPEED = 600.0
const LIFETIME = 2.0

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	get_tree().create_timer(LIFETIME).timeout.connect(queue_free)
	queue_redraw()

func _physics_process(delta: float) -> void:
	position += direction * BULLET_SPEED * delta

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		area.die()
		queue_free()

func _draw() -> void:
	draw_circle(Vector2.ZERO, 4.0, Color(0.9, 0.9, 0.2))
