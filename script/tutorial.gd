extends CanvasLayer

func _ready():
	# Sembunyikan pop-up di awal
	hide_popup()

# Fungsi untuk menampilkan pop-up
func show_popup():
	visible = true

# Fungsi untuk menyembunyikan pop-up
func hide_popup():
	visible = false

# Fungsi untuk tombol close
func _on_close_button_pressed() -> void:
	hide_popup()
