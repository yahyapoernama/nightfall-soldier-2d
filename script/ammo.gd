extends ProgressBar

var AMMO:int = 10
var AMMO_NOW:int = AMMO

func _ready() -> void:
	max_value = AMMO
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass
	
#func _on_weapon_ammo_signal(ammo: int, ammo_now: int) -> void:
	#max_value = ammo
	#value = ammo_now
	
func use_ammo() -> void:
	AMMO_NOW -= 1
	value = AMMO_NOW

func reload_ammo() -> void:
	AMMO_NOW = 10
	value = AMMO_NOW
#
func _on_main_scene_child_entered_tree(node: Node) -> void:
	if node.has_signal('ammo_signal'):
		node.connect('ammo_signal', use_ammo)
	if node.has_signal('reload_signal'):
		node.connect('reload_signal', reload_ammo)

func _on_main_scene_ammo_signal() -> void:
	use_ammo()
