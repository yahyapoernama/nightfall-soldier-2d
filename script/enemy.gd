extends Area2D

@export var speed = 2
@onready var animation_enemy: AnimatedSprite2D = $AnimatedSprite2D
@onready var sprite := $AnimatedSprite2D
@onready var collision_enemy: CollisionShape2D = $CollisionShape2D
@onready var player = get_tree().get_root().get_node("MainScene/Player")

const SPEED = 34.0
var HEALTH:int = 3
var HEALTH_NOW:int = HEALTH
const POINT = 1 
const DAMAGE = 1

signal enemy_death

var direction: Vector2 = Vector2.ZERO
var initial_movement: bool = true

func _ready() -> void:
	animation_enemy.play("walk")
	set_direction_to_center()

func set_direction_to_center():
	var center_position = get_viewport_rect().size / 2
	direction = (center_position - position).normalized()
	
func _process(delta: float) -> void:
	if HEALTH_NOW <= 0:
		return
	if player:
		# Hitung arah ke pemain
		var direction_to_player = (player.global_position - global_position).normalized()
		var distance_to_attack = 75
		if player.PLAYER_DEAD:
			animation_enemy.play("idle")
		else:
			if player.position.x > position.x :
				if (player.position.x-position.x) < distance_to_attack :
					animation_enemy.play("attack")
					await get_tree().create_timer(3).timeout
				else :
					animation_enemy.flip_h = false
					animation_enemy.play("walk")
					position.x += speed/2
			elif player.position.x < position.x :
				if (position.x-player.position.x) < distance_to_attack :
					animation_enemy.play("attack")
					await get_tree().create_timer(3).timeout
				else :
					animation_enemy.flip_h = true
					animation_enemy.play("walk")
					position.x -= speed/2
		

func set_random_direction():
	var angle = randf() * TAU
	direction = Vector2(cos(angle), sin(angle)).normalized()  

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group('player-bullet'):
		HEALTH_NOW -= area.DAMAGE
		area.queue_free()

	if HEALTH_NOW <= 0:
		animation_enemy.play("dead")
		collision_enemy.queue_free()
		emit_signal("enemy_death", POINT)
		await animation_enemy.animation_finished
		queue_free()


func _on_animated_sprite_2d_animation_looped() -> void:
	if player:
		if !player.PLAYER_DEAD:
			if animation_enemy.animation == "attack" && player.HEALTH_NOW > 0:
				print("Animasi attack telah selesai 1 loop")
				player.HEALTH_NOW -= 1
				player.HEALTH_NOW = clamp(player.HEALTH_NOW, 0, player.HEALTH)
				player.emit_signal("health_signal", player.HEALTH, player.HEALTH_NOW)
				print("HP berkurang")
			if player.HEALTH_NOW == 0:
				player.PLAYER_DEAD = true
				player.animation_player.play("dead")
				animation_enemy.play("idle")
				animation_enemy.stop()
	else:
		print("HP tidak berkurang")
	pass # Replace with function body.
