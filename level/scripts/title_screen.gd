extends Control


func _ready() -> void:
	$AudioStreamPlayer.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://level/word_01.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
