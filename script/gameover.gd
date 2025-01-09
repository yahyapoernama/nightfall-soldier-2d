extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide_popup()

# Fungsi untuk menampilkan pop-up
func show_popup():
	visible = true
	get_tree().paused = true  # Pause game saat pop-up muncul

# Fungsi untuk menyembunyikan pop-up
func hide_popup():
	visible = false
	get_tree().paused = false  # Unpause game saat pop-up ditutup

func _on_play_again_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/world.tscn")

func _on_close_button_pressed() -> void:
	hide_popup()
	get_tree().change_scene_to_file("res://scene/menu.tscn")
