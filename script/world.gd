extends Node2D

var ENEMY = preload("res://scene/enemy.tscn")
var is_first_loop = true

signal ammo_signal

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	emit_signal("ammo_signal")
	spawnEnemy()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

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
