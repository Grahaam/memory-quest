extends Node
## Global game state singleton (autoload).
## Tracks story progress, unlocked companions/abilities, and collected fragments.
## Access from anywhere as `GameState.xxx` (no need to instance or preload).

signal ability_unlocked(ability_id: StringName)
signal companion_unlocked(companion_id: StringName)
signal fragment_collected(chapter_id: StringName, fragment_id: StringName)
signal chapter_completed(chapter_id: StringName)

## Ordered list of chapter ids, matching the timeline structure.
const CHAPTER_ORDER: Array[StringName] = [
	&"prologue_bunny_chirami",
	&"chapter_01_falling_in_love",
	&"chapter_02_cat_amy",
	&"chapter_03_rotterdam_bunny",
	&"chapter_04_stray_cat",
	&"finale",
]

var current_chapter_id: StringName = &"prologue_bunny_chirami"

## companion_id -> bool
var unlocked_companions: Dictionary = {}

## ability_id -> bool
var unlocked_abilities: Dictionary = {}

## chapter_id -> Array[StringName] of collected fragment ids
var collected_fragments: Dictionary = {}

## chapter_id -> Vector3 respawn position of the last checkpoint reached
var checkpoints: Dictionary = {}

## chapter_id -> Array[StringName] of memory zones (title cards) already shown
var seen_zones: Dictionary = {}


func unlock_companion(companion_id: StringName) -> void:
	if unlocked_companions.get(companion_id, false):
		return
	unlocked_companions[companion_id] = true
	companion_unlocked.emit(companion_id)


func unlock_ability(ability_id: StringName) -> void:
	if unlocked_abilities.get(ability_id, false):
		return
	unlocked_abilities[ability_id] = true
	ability_unlocked.emit(ability_id)


func has_ability(ability_id: StringName) -> bool:
	return unlocked_abilities.get(ability_id, false)


func has_companion(companion_id: StringName) -> bool:
	return unlocked_companions.get(companion_id, false)


func collect_fragment(chapter_id: StringName, fragment_id: StringName) -> void:
	var chapter_fragments: Array = collected_fragments.get(chapter_id, [])
	if fragment_id in chapter_fragments:
		return
	chapter_fragments.append(fragment_id)
	collected_fragments[chapter_id] = chapter_fragments
	fragment_collected.emit(chapter_id, fragment_id)


func has_fragment(chapter_id: StringName, fragment_id: StringName) -> bool:
	return fragment_id in collected_fragments.get(chapter_id, [])


func fragment_count(chapter_id: StringName) -> int:
	return collected_fragments.get(chapter_id, []).size()


func set_checkpoint(chapter_id: StringName, position: Vector3) -> void:
	checkpoints[chapter_id] = position


func get_checkpoint(chapter_id: StringName) -> Variant:
	return checkpoints.get(chapter_id)


## Returns true the first time a zone is seen in this chapter, false after.
func mark_zone_seen(chapter_id: StringName, zone_id: StringName) -> bool:
	var zones: Array = seen_zones.get(chapter_id, [])
	if zone_id in zones:
		return false
	zones.append(zone_id)
	seen_zones[chapter_id] = zones
	return true


## Forget all progress inside a chapter (used by "play again").
func reset_chapter(chapter_id: StringName) -> void:
	collected_fragments.erase(chapter_id)
	checkpoints.erase(chapter_id)
	seen_zones.erase(chapter_id)


func complete_chapter(chapter_id: StringName) -> void:
	checkpoints.erase(chapter_id)
	current_chapter_id = _next_chapter_after(chapter_id)
	chapter_completed.emit(chapter_id)


func _next_chapter_after(chapter_id: StringName) -> StringName:
	var idx: int = CHAPTER_ORDER.find(chapter_id)
	if idx == -1 or idx + 1 >= CHAPTER_ORDER.size():
		return chapter_id
	return CHAPTER_ORDER[idx + 1]
