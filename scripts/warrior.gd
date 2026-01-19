extends Area2D

signal hit

@export var speed = 400
var screen_size

func _ready() -> void:
	hide()
	screen_size = get_viewport_rect().size * 0.5
	$AnimatedSprite2D.play()

func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.animation = "walk"
	else:
		$AnimatedSprite2D.animation = "idle"
		
	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0
		
	position += velocity * delta
	position = position.clamp(-screen_size, screen_size)


func _on_body_entered(body: Node2D) -> void:
	hit.emit()
	hide()
	$CollisionShape2D.set_deferred("disabled", true)

func spawn(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
