class_name Checkpoint
extends Area3D
## Touching the flag saves this spot; falling reloads the chapter and
## respawns the player here instead of at the start.

var _reached: bool = false

@onready var _flag: Node3D = $Flag


func _ready() -> void:
	var saved: Variant = GameState.get_checkpoint(GameState.current_chapter_id)
	if saved is Vector3 and (saved as Vector3).is_equal_approx(global_position):
		_reached = true
		_flag.scale = Vector3.ONE


func _on_body_entered(body: Node3D) -> void:
	if _reached or not body is Player:
		return
	_reached = true
	GameState.set_checkpoint(GameState.current_chapter_id, global_position)
	Audio.play("res://sounds/coin.ogg")
	_flag.scale = Vector3(0.6, 1.6, 0.6)


func _process(delta: float) -> void:
	var target := Vector3.ONE if _reached else Vector3(1, 0.6, 1)
	_flag.scale = _flag.scale.lerp(target, delta * 8)
