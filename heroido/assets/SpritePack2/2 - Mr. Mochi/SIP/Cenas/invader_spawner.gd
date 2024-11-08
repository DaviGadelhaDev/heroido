extends Node2D

class_name Invader_Spawner

signal invader_destroyed(points: int)
signal game_won
signal game_lost

const rows = 5
const columns = 11
const horizontal_spacing = 32
const vertical_spacing = 5
const invader_height = 24
const start_y = -50
const position_x_increment = 10
const position_y_increment = 20

var movement_direction = 1
var invader_scene = preload("res://Cenas/invader.tscn")
@onready var timer = $Timer
@onready var shot_timer = $ShotTimer
var invader_shot_scene = preload("res://Cenas/invader_shot.tscn")
var invader_destroyed_count = 0
var invader_total_count = rows * columns

func _ready():
	var invader_1 = preload("res://Resources/invader_1.tres")
	var invader_2 = preload("res://Resources/invader_2.tres")
	var invader_3 = preload("res://Resources/invader_3.tres")
	var invader_config
	
	for row in rows:
		if row == 0:
			invader_config = invader_1
		elif row == 1 || row == 2:
			invader_config = invader_2
		elif row == 3 || row == 4:
			invader_config = invader_3
		
		var row_width = (columns * invader_config.width * 3) + ((columns - 1) * horizontal_spacing)
		var start_x = (position.x - row_width) / 2
		
		for col in columns:
			var x = start_x + (col * invader_config.width * 3) + (col * horizontal_spacing)
			var y = start_y + (row * invader_height) + (row * vertical_spacing)
			var spawner_position = Vector2(x,y)
			invader_spawner(invader_config, spawner_position)

func invader_spawner(invader_config, spawner_position: Vector2):
	var invader = invader_scene.instantiate() as Invader
	invader.config = invader_config
	invader.global_position = spawner_position
	invader.invader_destroyed.connect(on_invader_destroyed)
	add_child(invader)
	
func on_invader_destroyed(points: int):
	invader_destroyed.emit(points)
	invader_destroyed_count += 1
	if invader_destroyed_count == invader_total_count:
		game_won.emit()
		shot_timer.stop()
		timer.stop()
	
	
func _process(delta):
	pass


func _on_timer_timeout():
	position.x += position_x_increment * movement_direction


func _on_left_wall_area_entered(area: Area2D) -> void:
	if(movement_direction == -1):
		position.y += position_y_increment
		movement_direction *= -1


func _on_right_wall_area_entered(area: Area2D) -> void:
	if(movement_direction == 1):
		position.y += position_y_increment
		movement_direction *= -1


func _on_shot_timer_timeout() -> void:
	var shot_position = get_children().filter(func(child): return child as Invader).map(func(invader): return invader.global_position).pick_random()
	var invader_shot = invader_shot_scene.instantiate() as InvaderShot
	invader_shot.global_position = shot_position
	get_tree().root.add_child(invader_shot)


func _on_bottom_wall_area_entered(area: Area2D) -> void:
	game_lost.emit()
	timer.stop()
	movement_direction = 0
