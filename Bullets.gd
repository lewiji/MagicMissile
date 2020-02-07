extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
export var maxBullets = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var bullet = get_node('Bullet')
	for i in range(1, maxBullets):
		add_child(bullet.duplicate())

func shootAt(enemy):
	for bullet in get_children():
		if (!bullet.shooting):
			bullet.shootAt(enemy)
			return
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
