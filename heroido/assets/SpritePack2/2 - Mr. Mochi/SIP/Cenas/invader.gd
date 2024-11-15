extends Area2D

class_name Invader

signal invader_destroyed(points: int)
@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer
var config: Resource

func _ready():
	sprite_2d.texture = config.sprite
	animation_player.play(config.animation_name)

func _process(delta):
	pass


func _on_area_entered(area: Area2D) -> void:
	if area is Laser:
		animation_player.play("destroy")
		area.queue_free()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "destroy":
		queue_free()
		invader_destroyed.emit(config.points)
