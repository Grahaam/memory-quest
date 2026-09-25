class_name Chapter
extends "res://scripts/main.gd"
## Root script for a chapter scene. Tells GameState which chapter is
## running so fragments and the HUD can file their data under it.

@export var chapter_id: StringName = &""


func _enter_tree() -> void:
	# _enter_tree runs parent-first, so this is set before any child
	# (fragments, HUD) reaches its own _ready().
	if chapter_id != &"":
		GameState.current_chapter_id = chapter_id
