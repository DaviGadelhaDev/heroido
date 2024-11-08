extends CharacterBody2D


const SPEED = 200.0
const JUMP_FORCE = -400.0
var is_jumping := false
@onready var animation := $anim as AnimatedSprite2D

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_FORCE
		is_jumping = true
	elif is_on_floor():
		is_jumping = false

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * SPEED
		animation.scale.x = direction
		if not is_jumping:
			animation.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animation.play("idle")
		
	if is_jumping:
		animation.play("jump")

	move_and_slide()
