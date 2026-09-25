class_name CompanionProximityAbility
extends AbilityComponent
## Chapter 2 mechanic (cat companion, abandonment anxiety theme):
## the level/companion becomes unstable the further the player strays.
## Emits signals so chapter scenes can hook up visual/audio distortion
## (e.g. shader params, platform flicker) without this script knowing
## about presentation details.

signal stability_changed(stability: float) ## 1.0 = calm, 0.0 = fully destabilized
signal companion_panicked
signal companion_soothed

@export var companion_path: NodePath
@export var safe_distance: float = 4.0
@export var critical_distance: float = 10.0

var _is_panicked: bool = false
var _companion: Node3D


func _on_ready() -> void:
	_companion = get_node_or_null(companion_path) as Node3D


func _process(_delta: float) -> void:
	if not _companion or not player:
		return

	var distance: float = player.global_position.distance_to(_companion.global_position)
	var stability: float = 1.0 - clampf(
		(distance - safe_distance) / (critical_distance - safe_distance), 0.0, 1.0
	)
	stability_changed.emit(stability)

	var should_be_panicked: bool = distance >= critical_distance
	if should_be_panicked and not _is_panicked:
		_is_panicked = true
		companion_panicked.emit()
	elif not should_be_panicked and _is_panicked and distance <= safe_distance:
		_is_panicked = false
		companion_soothed.emit()
