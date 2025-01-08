extends Control

var tutorial_popup = preload("res://scene/tutorial.tscn")
var tutorial_instantiate = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Instance pop-up dan tambahkan ke scene
	tutorial_instantiate = tutorial_popup.instantiate()
	add_child(tutorial_instantiate)
	tutorial_instantiate.hide_popup()  # Sembunyikan pop-up di awal


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/world.tscn")


func _on_tutorial_button_pressed() -> void:
	tutorial_instantiate.show_popup()  # Tampilkan pop-up


func _on_exit_button_pressed() -> void:
	get_tree().quit()
