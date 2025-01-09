extends CanvasLayer

var tutorial_popup = preload("res://scene/tutorial.tscn")
var tutorial_instantiate = null

func _ready():
	# Sembunyikan pop-up di awal
	hide_popup()
	# Instance pop-up dan tambahkan ke scene
	tutorial_instantiate = tutorial_popup.instantiate()
	add_child(tutorial_instantiate)
	tutorial_instantiate.hide_popup()  # Sembunyikan pop-up di awal

# Fungsi untuk menampilkan pop-up
func show_popup():
	visible = true
	get_tree().paused = true  # Pause game saat pop-up muncul

# Fungsi untuk menyembunyikan pop-up
func hide_popup():
	visible = false
	get_tree().paused = false  # Unpause game saat pop-up ditutup

# Fungsi untuk tombol close
func _on_close_button_pressed() -> void:
	hide_popup()

func _on_tutorial_button_pressed() -> void:
	tutorial_instantiate.show_popup()  # Tampilkan pop-up

func _on_exit_button_pressed() -> void:
	hide_popup()
	get_tree().change_scene_to_file("res://scene/menu.tscn")
