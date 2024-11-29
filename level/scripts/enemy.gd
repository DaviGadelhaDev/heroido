extends CharacterBody2D


const SPEED = 700.0
const JUMP_VELOCITY = -400.0

@onready var wall_detector := $wall_detector as RayCast2D
@onready var anim: AnimationPlayer = $anim
@onready var animated_sprite_2d = $AnimatedSprite2D

var direction := -1

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if wall_detector.is_colliding():
		direction *= -1
		wall_detector.scale.x *= -1
	if direction == 1:
		animated_sprite_2d.flip_h = true
	else:
		animated_sprite_2d.flip_h = false
	velocity.x = direction * SPEED * delta
	
	move_and_slide()
