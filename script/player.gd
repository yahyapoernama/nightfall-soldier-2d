extends CharacterBody2D

# Variabel untuk mengecek apakah tombol sedang ditahan
var is_shooting: bool = false

@onready var health_bar = get_tree().get_root().get_node("MainScene/CanvasLayer/HealthLabel/Health")  # Path menuju node ProgressBar di scene

# Referensi ke node AudioStreamPlayer untuk SFX
@onready var shoot_sfx = $SFXShoot

# Timer untuk durasi minimal
@onready var min_duration_timer = $SFXShootTimer

enum PLAYER_DIRECTION {LEFT, RIGHT}
var PLAYER_WALK = false
var PLAYER_SHOOT = false
var PLAYER_DEAD = false

const SPEED = 64.0
const TURN_SPEED = 2
const ROTATE_SPEED = 20
const NITRO_SPEED = 130
var HEALTH:int = 10
var HEALTH_NOW:int = HEALTH
var ammo:Node

signal health_signal(health:int, healthnow:int)
signal death_signal(isTrue:bool)
signal ammo_signal
signal reload_signal

var direction := Vector2.RIGHT
var player_direction : PLAYER_DIRECTION = PLAYER_DIRECTION.LEFT

func change_direction(new_direction: PLAYER_DIRECTION):
	player_direction = new_direction

@onready var weapon: Weapon = $Weapon as Weapon
@onready var animation_player: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	emit_signal("health_signal", HEALTH, HEALTH_NOW)
	change_direction(PLAYER_DIRECTION.RIGHT)
	animation_player.play("idle")
	ammo = get_tree().get_root().get_node("MainScene/CanvasLayer/AmmoLabel/Ammo")
	
	# Memuat file SFX ke dalam AudioStreamPlayer2D
	var sfx_stream = load("res://assets/sound/SFX-Shoot.ogg")  # Ganti dengan path SFX Anda
	
	# Atur looping pada stream
	sfx_stream.loop = true  # <-- Ini yang benar
	
	# Set stream ke AudioStreamPlayer2D
	shoot_sfx.stream = sfx_stream

	# Atur durasi timer minimal (1 detik)
	min_duration_timer.wait_time = 0.5  # 1 detik
	min_duration_timer.one_shot = true  # Timer hanya berjalan sekali
	
func _physics_process(delta: float):
	# Dapatkan batas layar (Rect2) dalam koordinat global
	var viewport_rect = get_viewport_rect()
	var direction_left := Input.get_action_strength("turn_left")
	var direction_right := Input.get_action_strength("turn_right")
	var input_direction := Vector2(direction_right - direction_left, 0)
	var velocity = Vector2.ZERO  # Inisialisasi kecepatan
	var current_speed = SPEED
	if !PLAYER_DEAD:
		if input_direction.x != 0:
			if Input.is_action_pressed("turn_left"):
				animation_player.flip_h = input_direction.x < 0  # Membalik sprite jika bergerak ke kiri
				change_direction(PLAYER_DIRECTION.LEFT)
				position.x -= 5
				animation_player.play("run")	
				PLAYER_WALK = true
			if Input.is_action_pressed("turn_right"):
				animation_player.flip_h = input_direction.x < 0
				change_direction(PLAYER_DIRECTION.RIGHT)
				position.x += 5
				animation_player.play("run")
				PLAYER_WALK = true
			velocity = direction.normalized() * (input_direction.x + 100) * current_speed
			$Reload.stop()
		else :
			velocity = Vector2.ZERO
			if ["turn_left", "turn_right", "shoot"].any(Input.is_action_just_released):
				animation_player.play("idle")
				PLAYER_SHOOT = false
				$Shoot.stop()
			if Input.is_action_just_pressed("reload"):
				animation_player.play("reload")
				$Reload.start()
			if Input.is_action_just_pressed("shoot"):
				$Shoot.start()
				if ammo.AMMO_NOW > 0:
					#start_shooting()  # Mulai memutar SFX
					emit_signal("ammo_signal")
			if Input.is_action_pressed("shoot"):
				if ammo.AMMO_NOW > 0:
					animation_player.play("shoot")
					#await get_tree().create_timer(1).timeout
					PLAYER_SHOOT = true
					weapon.fire()
					start_shooting()  # Mulai memutar SFX
					await stop_shooting()  # Hentikan SFX
				else:
					animation_player.play("idle")
					PLAYER_SHOOT = false
			PLAYER_WALK = false
		# Jika tombol sedang ditahan dan timer sudah selesai, loop SFX
		if is_shooting and min_duration_timer.is_stopped() and not shoot_sfx.playing:
			shoot_sfx.play()
	
	# Batasi posisi player agar tetap di dalam layar
	position.x = clamp(position.x, viewport_rect.position.x-525, viewport_rect.position.x + viewport_rect.size.x - 600)
	position.y = clamp(position.y, viewport_rect.position.y, viewport_rect.position.y + viewport_rect.size.y)
	
	move_and_slide()

func _input(event):
	if event.is_action_pressed("shoot"):
		weapon.fire()

func _on_shoot_timeout() -> void:
	if ammo.AMMO_NOW > 0:
		emit_signal("ammo_signal")
	pass # Replace with function body.

func _on_reload_timeout() -> void:
	emit_signal("reload_signal")
	$Reload.stop()
	await animation_player.animation_finished
	animation_player.play("idle")
	pass # Replace with function body.

func start_shooting():
	if not is_shooting:
		is_shooting = true
		shoot_sfx.play()  # Mulai memutar SFX
		min_duration_timer.start()  # Mulai timer durasi minimal

func stop_shooting():
	# Tunggu hingga durasi minimal terpenuhi
	if not min_duration_timer.is_stopped():
		await min_duration_timer.timeout  # Tunggu hingga timer selesai

	# Hentikan SFX setelah durasi minimal terpenuhi
	is_shooting = false
	shoot_sfx.stop()  # Hentikan SFX
