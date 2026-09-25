class_name Chapter
extends "res://scripts/main.gd"
## Root script for a chapter scene. Tells GameState which chapter is
## running, respawns the player at the last checkpoint after a fall, and
## plays the opening / closing cards.

@export var chapter_id: StringName = &""
@export var chapter_title: String = ""
## Shown big on the end screen (e.g. the real date the memory ends on).
@export var ending_date: String = ""

@onready var _player: Player = $Player
@onready var _view: Node3D = $View
@onready var _ui: ChapterUI = get_node_or_null("ChapterUI")


func _enter_tree() -> void:
	# _enter_tree runs parent-first, so this is set before any child
	# (fragments, HUD) reaches its own _ready().
	if chapter_id != &"":
		GameState.current_chapter_id = chapter_id


func _ready() -> void:
	super()
	var checkpoint: Variant = GameState.get_checkpoint(chapter_id)
	if checkpoint is Vector3:
		_player.global_position = checkpoint + Vector3.UP * 0.5
		_view.global_position = _player.global_position
	elif _ui and chapter_title != "":
		_ui.show_card(chapter_title)

	var partner: Partner = find_child("Partner", true, false)
	if partner:
		partner.reached.connect(_on_partner_reached)
	if _ui:
		_ui.replay_requested.connect(_on_replay_requested)


func _on_partner_reached() -> void:
	var total := get_tree().get_nodes_in_group(MemoryFragment.GROUP).size()
	var found := GameState.fragment_count(chapter_id)
	GameState.complete_chapter(chapter_id)
	await get_tree().create_timer(2.5).timeout
	if _ui:
		_ui.show_ending(ending_date, chapter_title, found, total)


func _on_replay_requested() -> void:
	GameState.reset_chapter(chapter_id)
	get_tree().reload_current_scene()
