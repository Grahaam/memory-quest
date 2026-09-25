class_name ChapterUI
extends CanvasLayer
## Story overlay for a chapter: memory captions, date/title cards and the
## end screen. Gameplay objects talk to it through the "chapter_ui" group
## (get_tree().call_group), so they work even in scenes without this UI.

signal replay_requested

const GROUP: StringName = &"chapter_ui"
const CAPTION_HOLD: float = 3.5
const CARD_HOLD: float = 2.8
const FADE: float = 0.6

var _card_queue: Array[PackedStringArray] = []
var _card_busy: bool = false
var _caption_tween: Tween
var _waiting_for_replay: bool = false

@onready var _caption: Label = $Caption
@onready var _card: Control = $Card
@onready var _card_title: Label = $Card/Title
@onready var _card_subtitle: Label = $Card/Subtitle
@onready var _ending: Control = $Ending
@onready var _end_date: Label = $Ending/Box/Date
@onready var _end_title: Label = $Ending/Box/Title
@onready var _end_stats: Label = $Ending/Box/Stats
@onready var _end_hint: Label = $Ending/Box/Hint


func _ready() -> void:
	add_to_group(GROUP)
	_caption.modulate.a = 0.0
	_card.modulate.a = 0.0
	_ending.modulate.a = 0.0
	_ending.visible = false


func show_caption(text: String) -> void:
	_caption.text = text
	if _caption_tween:
		_caption_tween.kill()
	_caption_tween = create_tween()
	_caption_tween.tween_property(_caption, "modulate:a", 1.0, FADE * 0.5)
	_caption_tween.tween_interval(CAPTION_HOLD)
	_caption_tween.tween_property(_caption, "modulate:a", 0.0, FADE)


func show_card(title: String, subtitle: String = "") -> void:
	_card_queue.append(PackedStringArray([title, subtitle]))
	if not _card_busy:
		_next_card()


func _next_card() -> void:
	if _card_queue.is_empty():
		_card_busy = false
		return
	_card_busy = true
	var entry: PackedStringArray = _card_queue.pop_front()
	_card_title.text = entry[0]
	_card_subtitle.text = entry[1]
	var tween := create_tween()
	tween.tween_property(_card, "modulate:a", 1.0, FADE)
	tween.tween_interval(CARD_HOLD)
	tween.tween_property(_card, "modulate:a", 0.0, FADE)
	tween.tween_callback(_next_card)


func show_ending(date_text: String, chapter_title: String, found: int, total: int) -> void:
	_end_date.text = date_text
	_end_title.text = chapter_title
	_end_stats.text = "Memories recovered: %d / %d" % [found, total]
	_end_hint.modulate.a = 0.0
	_ending.visible = true
	var tween := create_tween()
	tween.tween_property(_ending, "modulate:a", 1.0, 1.5)
	tween.tween_interval(1.0)
	tween.tween_property(_end_hint, "modulate:a", 1.0, FADE)
	tween.tween_callback(func() -> void: _waiting_for_replay = true)


func _unhandled_input(event: InputEvent) -> void:
	if _waiting_for_replay and event.is_action_pressed("jump"):
		_waiting_for_replay = false
		replay_requested.emit()
