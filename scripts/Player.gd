extends CharacterBody2D

@export var speed: float = 320.0
@export var max_health: int = 5
@export var bullet_scene: PackedScene

var health: int
var aim_dir: Vector2 = Vector2.RIGHT

signal health_changed(current: int, max: int)
signal died

func _ready() -> void:
	health = max_health
	emit_signal("health_changed", health, max_health)

func _physics_process(delta: float) -> void:
	var dir := Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)

	if dir.length() > 0.0:
		dir = dir.normalized()
		aim_dir = dir

	velocity = dir * speed
	move_and_slide()

	if Input.is_action_just_pressed("shoot"):
		shoot()

func shoot() -> void:
	if bullet_scene == null:
		return
	var b = bullet_scene.instantiate()
	get_tree().current_scene.add_child(b)
	b.global_position = $Muzzle.global_position
	b.direction = aim_dir

func take_damage(amount: int = 1) -> void:
	health -= amount
	emit_signal("health_changed", health, max_health)
	if health <= 0:
		emit_signal("died")
		queue_free()


func _on_bullet_body_entered(body: Node2D) -> void:
	pass 


func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(1)
