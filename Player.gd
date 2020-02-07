extends RigidBody2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var last_pressed_position
var SPEED = 200
var swipe_speed = Vector2(0, 0)
var average_swipe_speed_array = [Vector2(0, 0), Vector2(0, 0), Vector2(0, 0)]
var average_swipe_speed = Vector2(0, 0)
var average_swipe_speed_idx = 0

var _velocity = Vector2(0,0)
var EnemyList
var tick = 0
var shooting = false
var shootEverySeconds = 1
var Bullets

var health = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EnemyList = get_node('../../EnemiesInRange')
	Bullets = get_node('Bullets')
	set_process(true)
	$Sprite.play('run')

func shoot(enemy):
	Bullets.shootAt(enemy)
	pass
	
func process_swipe_speed(delta):
	if (average_swipe_speed_array.size() == 3):
		average_swipe_speed = (average_swipe_speed_array[0] + average_swipe_speed_array[1] + average_swipe_speed_array[2]) / 3
	average_swipe_speed_array[average_swipe_speed_idx] = swipe_speed
	average_swipe_speed_idx += 1
	if average_swipe_speed_idx > 2:
		average_swipe_speed_idx = 0

func process_movement(delta):
	if (last_pressed_position != null):
		var direction = average_swipe_speed * 0.3
		var length = direction.length()
		if length < 2: #2px, experiment with this value
			if length < 0.5:
				_velocity = Vector2(0,0) # full stop.
			else:
				_velocity = direction * SPEED * delta # sloooooowly
		else:
			_velocity = direction * SPEED * delta
		
func process_enemies():
	# Get enemies in range from singleton and determine whether to shoot
	if EnemyList != null:
		if EnemyList.enemies.size() == 0:
			shooting = false
		elif !shooting || tick > shootEverySeconds:
			tick = 0
			shooting = true
			for Enemy in EnemyList.enemies:
				shoot(Enemy)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if health > 0:
		process_enemies()
		process_swipe_speed(delta)
		process_movement(delta)
		tick += delta
	else:
		$Sprite.modulate = 512121;

func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	state.set_linear_velocity(_velocity)

func _on_InputManager_any_gesture(sig, val) -> void:
	if (sig == 'twist'):
		last_pressed_position = val.position
		swipe_speed = val.speed


func _on_RigidBody2D_body_entered(body: Node) -> void:
	if body.collision_layer == 8:
		print('got hit')
		health -= 20
		get_node('../ProgressBar').value = health
		body.shooting = false
	pass # Replace with function body.
