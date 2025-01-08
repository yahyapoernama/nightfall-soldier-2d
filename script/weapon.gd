extends Node2D
class_name Weapon

enum STATES {READY, FIRING, RELOADING, COOLDOWN}

@onready var BULLET_SCENE = load("res://scene/bullet.tscn") as PackedScene
@onready var PLAYER_SCENE = load("res://scene/player.tscn") as PackedScene
@onready var cooldown_timer: Timer = $Timer

var state:STATES = STATES.READY 
var player:Node
var ammo:Node

func _ready() -> void:
	player = get_tree().get_root().get_node("MainScene/Player")
	ammo = get_tree().get_root().get_node("MainScene/CanvasLayer/AmmoLabel/Ammo")
	pass # Replace with function body.
	
func change_state(new_state: STATES):
	state = new_state
	cooldown_timer.start()
	
func fire():
	if player.PLAYER_WALK || player.PLAYER_DEAD :
		return
		
	if ammo.AMMO_NOW <= 0:
		return
		
	if state == STATES.FIRING || state == STATES.RELOADING || state == STATES.COOLDOWN:
		return
		
	change_state(STATES.FIRING)
	if BULLET_SCENE:
		var bullet = BULLET_SCENE.instantiate()
		if player.player_direction == player.PLAYER_DIRECTION.LEFT:
			bullet.direction = Vector2(-1, 0)
			bullet.global_position = global_position + Vector2(-50, -20)
		else:
			bullet.direction = Vector2(1, 0)
			bullet.global_position = global_position + Vector2(50, -20)
		bullet.add_to_group('player-bullet')
		move_to_front()
		get_tree().root.add_child(bullet)
		
	else:
		print("BULLET_SCENE is null! Please set it in the editor.")
	

func enemy_fire():
	pass
	
func _on_timer_timeout():
	change_state(STATES.READY)
