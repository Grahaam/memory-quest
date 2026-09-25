class_name AbilityComponent
extends Node
## Base class for a chapter-specific gameplay mechanic ("power").
## Attach a subclass as a child of the Player scene in the chapter that
## introduces it. Keeping each power as its own node means chapters can
## mix and match abilities (e.g. the finale attaches all of them) without
## the base Player script knowing anything about them.

## Unique id registered with GameState when this ability is unlocked.
@export var ability_id: StringName = &""

var player: Player


func _ready() -> void:
	player = get_parent() as Player
	if ability_id != &"":
		GameState.unlock_ability(ability_id)
	_on_ready()


## Override in subclasses instead of _ready().
func _on_ready() -> void:
	pass
