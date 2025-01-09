extends Node2D

@onready var player = get_tree().get_root().get_node("MainScene/Player")

var ENEMY = preload("res://scene/enemy.tscn")
var is_first_loop = true

var pause_popup = preload("res://scene/pause.tscn")
var pause_instantiate = null
var gameover_popup = preload("res://scene/gameover.tscn")
var gameover_instantiate = null

signal ammo_signal

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	emit_signal("ammo_signal")
	spawnEnemy()
	
	# Instance pop-up dan tambahkan ke scene
	pause_instantiate = pause_popup.instantiate()
	add_child(pause_instantiate)
	pause_instantiate.hide_popup()  # Sembunyikan pop-up di awal
	
	gameover_instantiate = gameover_popup.instantiate()
	add_child(gameover_instantiate)
	gameover_instantiate.hide_popup()  # Sembunyikan pop-up di awal

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player.HEALTH_NOW == 0:
		save_high_score_to_documents()
		gameover_instantiate.get_node(
			"OverlayPanel/VBoxContainer/ScoreValue"
		).text = str(get_node("CanvasLayer/ScoreLabel/Score").POINT)
		gameover_instantiate.get_node(
			"OverlayPanel/VBoxContainer/HighscoreInfo"
		).text = "Highscore : " + str(load_score_from_documents())
		gameover_instantiate.show_popup()  # Tampilkan pop-up

func spawnEnemy():
	var enemy = ENEMY.instantiate()
	enemy.scale = Vector2(1.88, 1.88)
	enemy.add_to_group('enemy-body')

	# Mendapatkan ukuran viewport
	var viewport_size = get_viewport().size

	var side
	if is_first_loop:
		side = 1  # Paksa sisi kanan pada iterasi pertama
		is_first_loop = false  # Setelah iterasi pertama, matikan flag
	else:
		side = randi() % 2  # Pilih sisi secara acak untuk iterasi berikutnya

	match side:
		0: # Kiri
			enemy.position = Vector2(-600, 213)
		1: # Kanan
			enemy.position = Vector2(600, 213)

	add_child(enemy)

func _on_timer_timeout() -> void:
	var enemy_count = (len(get_tree().get_nodes_in_group('enemy-body')))
	if enemy_count <= 10 :
		spawnEnemy()

func _on_tutorial_button_pressed() -> void:
	pause_instantiate.show_popup()  # Tampilkan pop-up


func ensure_subfolder_exists():
	var documents_path = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)
	var subfolder_path = documents_path + "/Nightfall Soldier"  # Gabungkan path dengan subfolder

	var dir = DirAccess.open(documents_path)  # Buka akses ke direktori Documents
	if dir:
		if !dir.dir_exists(subfolder_path):  # Cek apakah subfolder sudah ada
			dir.make_dir(subfolder_path)  # Buat subfolder jika belum ada
	else:
		print("Gagal membuka direktori Documents!")
	return subfolder_path

func save_high_score_to_documents():
	var subfolder_path = ensure_subfolder_exists()  # Pastikan subfolder ada
	var file_path = subfolder_path + "/score.dat"  # Gabungkan path dengan nama file
	var score = get_node("CanvasLayer/ScoreLabel/Score").POINT

	var saved_score = load_score_from_documents()  # Muat skor yang tersimpan
	if score > saved_score:  # Bandingkan skor saat ini dengan skor tersimpan
		var file = FileAccess.open(file_path, FileAccess.WRITE)  # Buka file untuk menulis
		if file:
			var data_to_save = str(score)  # Skor sebagai string
			var encrypted_data = Marshalls.utf8_to_base64(data_to_save)  # Enkripsi sederhana
			file.store_string(encrypted_data)  # Simpan data terenkripsi
			file.close()
		else:
			print("Gagal menyimpan skor!")
	else:
		print("Skor saat ini lebih rendah. Skor tersimpan tetap: ", saved_score)

func load_score_from_documents():
	var subfolder_path = ensure_subfolder_exists()  # Pastikan subfolder ada
	var file_path = subfolder_path + "/score.dat"  # Gabungkan path dengan nama file

	if FileAccess.file_exists(file_path):  # Cek apakah file ada
		var file = FileAccess.open(file_path, FileAccess.READ)  # Buka file untuk membaca
		if file:
			var encrypted_data = file.get_as_text()  # Baca data terenkripsi
			var decrypted_data = Marshalls.base64_to_utf8(encrypted_data)  # Dekripsi
			var saved_score = int(decrypted_data)  # Konversi kembali ke integer
			file.close()
			return saved_score
		else:
			print("Gagal membaca skor!")
	else:
		print("File skor tidak ditemukan!")
	return 0  # Kembalikan 0 jika file tidak ada atau gagal dibaca
