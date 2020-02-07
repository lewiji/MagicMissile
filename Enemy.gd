extends RigidBody2D

var EnemiesInRange
var enemies = ['imp', 'mimic', 'muddy', 'necro', 'ogre', 'orc', 'shaman', 'skeleton', 'swampy', 'zombie']
var _velocity = Vector2(0,0)
export var health = 100
var speed = 20
var direction = Vector2(0,0)
var tick = 0
var alive = true
var sprite
var attacking = false
var attack_tick = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EnemiesInRange = get_node('../../EnemiesInRange')
	sprite = get_node('Sprite')
	$Sprite.play(enemies[rand_range(0, enemies.size() - 1)])
	pickRandomMoveSpot()
	set_process(true)	
	
func _process(delta: float) -> void:
	if attacking:
		attack_tick += delta
		if (attack_tick > 2):
			get_node('Bullet').shootAt(get_node('../../Player/RigidBody2D'))
			attack_tick = 0
	else:
		attack_tick = 2.1
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if !alive:
		_velocity = Vector2(0,0)
		sprite.modulate = 512121
	else:
		sprite.modulate = 'ffffff'
		_velocity = direction * speed * delta
		if tick > (rand_range(50, 200) / 100):
			set_linear_velocity(Vector2(0,0))
			set_angular_velocity(0)
			pickRandomMoveSpot()
			tick = 0
	tick = tick + delta
	set_linear_velocity(_velocity)
	pass

func pickRandomMoveSpot():
	direction = (self.global_position - (self.global_position + Vector2(rand_range(-200,200),rand_range(-200,200))))
	
func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	pass#state.set_linear_velocity(_velocity)

func _on_PlayerDetector_body_exited(body: Node) -> void:
	attacking = false
	EnemiesInRange.remove(self)




func _on_PlayerDetector_body_entered(body: Node) -> void:
		if alive:
			attacking = true
			EnemiesInRange.add(self)

func _on_RigidBody2D_body_entered(body: Node) -> void:
	if body.collision_layer == 4:
		health = health - 34
		get_node('../ProgressBar').value = health
		if (health <= 0):
			_velocity = Vector2(0,0)
			set_linear_velocity(Vector2(0,0))
			EnemiesInRange.remove(self)
			alive = false
			attacking = false
