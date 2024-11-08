extends Node2D

@onready var spawn_timer = $SpawnTimer
var ufo_shot_scene = preload("res://Cenas/invader_shot.tscn")

func _ready() -> void:
	spawn_timer.setup_timer()

func _process(delta: float) -> void:
	pass

func _on_spawn_timer_timeout() -> void:
	var ufo_shot = ufo_shot_scene.instantiate()
	var ufo_shot_sprite = ufo_shot.get_node("Sprite2D") as Sprite2D
	ufo_shot_sprite.modulate = Color (0.62, 0.2, 0.2, 1)
	ufo_shot.global_position = global_position
	get_tree().root.add_child(ufo_shot)
	spawn_timer.setup_timer()
