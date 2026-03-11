extends CharacterBody2D

@export var speed: float = 150.0
@export var hp: int = 2

var target: Node2D

func _ready() -> void:
	add_to_group("enemies")

func _physics_process(delta: float) -> void:
	if target == null:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var dir := target.global_position - global_position
	if dir.length() > 0.0:
		velocity = dir.normalized() * speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()

func take_damage(amount: int = 1) -> void:
	hp -= amount
	if hp <= 0:
		queue_free()
