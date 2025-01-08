extends Area2D

const SPEED = 1000
const ENEMY_SPEED = 2000
const DAMAGE = 1

var direction : Vector2 = Vector2()

func _ready():
	pass
	
func _physics_process(delta: float):
	position += direction.normalized() * SPEED * delta

func shoot(target_position: Vector2):
	# Tentukan arah peluru menuju target
	direction = (target_position - position).normalized()
