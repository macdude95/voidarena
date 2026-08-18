extends Area2D

@export var speed: float = 100.0
var target: Node2D = null

func _ready() -> void:
	add_to_group("enemy")
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	if target and is_instance_valid(target):
		var direction = (target.global_position - global_position).normalized()
		position += direction * speed * delta

func die() -> void:
	var gm = get_tree().current_scene
	if gm.has_method("on_enemy_killed"):
		gm.on_enemy_killed()
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and body.has_method("die"):
		body.die()
