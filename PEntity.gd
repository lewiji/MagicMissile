extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(true)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	$ProgressBar.set_global_position($RigidBody2D.global_position + Vector2(-14, -25))
	pass

func _on_InputManager_any_gesture(sig, val) -> void:
	$RigidBody2D._on_InputManager_any_gesture(sig, val)
