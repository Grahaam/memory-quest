class_name Partner
extends Node3D
## The partner waiting at the end of a chapter. Reaching them plays the
## chapter's closing moment and hands over to the ChapterUI end screen.

signal reached

@export var tint: Color = Color(1.0, 0.78, 0.55)

var _done: bool = false

@onready var _model: Node3D = $Character
@onready var _hearts: CPUParticles3D = $Hearts


func _ready() -> void:
	_tint_model()
	var anim: AnimationPlayer = _model.find_child("AnimationPlayer", true, false)
	if anim:
		anim.play("idle")


func _on_trigger_body_entered(body: Node3D) -> void:
	if _done or not body is Player:
		return
	_done = true
	var player := body as Player
	player.controls_enabled = false
	# Face each other.
	var to_partner := global_position - player.global_position
	player.rotation_direction = Vector2(to_partner.z, to_partner.x).angle()
	rotation.y = Vector2(-to_partner.z, -to_partner.x).angle()
	_hearts.emitting = true
	Audio.play("res://sounds/coin.ogg")
	reached.emit()


func _tint_model() -> void:
	for mesh in _model.find_children("*", "MeshInstance3D", true, false):
		var mi := mesh as MeshInstance3D
		for i in mi.mesh.get_surface_count():
			var base := mi.mesh.surface_get_material(i) as StandardMaterial3D
			if base:
				var mat := base.duplicate() as StandardMaterial3D
				mat.albedo_color = tint
				mi.set_surface_override_material(i, mat)
