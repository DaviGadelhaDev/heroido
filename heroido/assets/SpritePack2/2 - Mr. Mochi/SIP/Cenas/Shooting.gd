extends Node2D

var laser_scene = preload("res://Cenas/laser.tscn")
var can_player_shoot = true

func _input(event):
	if Input.is_action_just_pressed("shoot") && can_player_shoot:
		var laser = laser_scene.instantiate() as Laser
		laser.global_position = get_parent().global_position - Vector2(0, 20)
		get_tree().root.add_child(laser)
		can_player_shoot = false
		laser.tree_exited.connect(_tree_exited)

func _tree_exited():
	can_player_shoot = true
	
func _ready():
	pass # Replace with function body.

func _process(delta):
	pass
