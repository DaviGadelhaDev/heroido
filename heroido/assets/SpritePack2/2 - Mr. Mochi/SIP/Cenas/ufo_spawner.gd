extends Node2D

@onready var spawn_timer = $SpawnTimer
var ufo_scene: PackedScene = preload("res://Cenas/ufo.tscn")

func _ready() -> void:
	(spawn_timer as SpawnTimer).setup_timer()

func _process(delta: float) -> void:
	pass


func _on_spawn_timer_timeout() -> void:
	var ufo = ufo_scene.instantiate() as Ufo
	ufo.global_position = position
	get_tree().root.add_child(ufo)
	(spawn_timer as SpawnTimer).setup_timer()
