extends Node


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var enemies = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func add(enemy):
	enemies.append(enemy)
	print('adding enemy:', enemy)
	
func remove(enemy):
	if (enemy != null):
		enemies.remove(enemies.find(enemy))
		print('removing enemy:', enemy)
