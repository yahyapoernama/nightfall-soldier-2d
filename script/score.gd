extends Label

var POINT:int = 0

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass

func add_point(point:Variant)->void:
	POINT += point
	text = str(POINT)

func _on_main_scene_child_entered_tree(node: Node) -> void:
	if node.has_signal('enemy_death'):
		node.connect('enemy_death', add_point)
