extends RigidBody2D

var shooting = false
export var bullet_speed = 25
var _enemy
var _velocity = Vector2(0,0)
var animationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animationPlayer = get_node('Sprite/AnimationPlayer')
	pass # Replace with function body.

func shootAt(enemy):
	_enemy = enemy.global_position
	set_angular_velocity(rand_range(0,30))
	transform = Transform2D(0, Vector2(0,0))
	linear_velocity = Vector2(0,0)
	shooting = true
	$Sprite.frame = rand_range(0, 19) 
	set_process(true)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if (_enemy != null):
		var direction = (_enemy - self.global_position) * 20
		_velocity = direction * bullet_speed * delta
	if !shooting:
		visible = false
		position = Vector2(0, 0)
		_velocity = Vector2(0, 0)
	else:
		visible = true
		
		if abs(angular_velocity) < 0.8 and _velocity < Vector2(1, 1):
			shooting = false

func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	if !shooting:
		state.transform = Transform2D(0, Vector2(0,0))
		state.linear_velocity = Vector2(0,0)
	else:
		state.set_linear_velocity(_velocity)




func _on_Bullet_body_entered(body: Node) -> void:
	shooting = false
	position = Vector2(0, 0)
	_velocity = Vector2(0, 0)
	_enemy = null
	pass # Replace with function body.


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	position = Vector2(0, 0)
	_velocity = Vector2(0, 0)
	_enemy = null
