class_name MemoryZone
extends Area3D
## Invisible trigger volume that shows a date / title card the first time
## the player walks into a new part of the memory.

@export var title: String = ""
@export_multiline var subtitle: String = ""


func _on_body_entered(body: Node3D) -> void:
	if not body is Player:
		return
	if GameState.mark_zone_seen(GameState.current_chapter_id, StringName(name)):
		get_tree().call_group(ChapterUI.GROUP, &"show_card", title, subtitle)
