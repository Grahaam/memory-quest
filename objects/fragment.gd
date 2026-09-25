class_name MemoryFragment
extends Area3D
## A collectible piece of memory. Records itself in GameState under the
## current chapter, so progress survives the scene reload on falling.

const GROUP: StringName = &"memory_fragments"

## Unique within its chapter. Defaults to the node name when left empty.
@export var fragment_id: StringName = &""

var chapter_id: StringName
var grabbed: bool = false
var time: float = 0.0


func _ready() -> void:
	add_to_group(GROUP)
	if fragment_id == &"":
		fragment_id = StringName(name)
	chapter_id = GameState.current_chapter_id

	if GameState.has_fragment(chapter_id, fragment_id):
		grabbed = true
		_show_as_already_collected()


## Called when the scene loads with this fragment already collected
## (e.g. the player picked it up, then fell and the level reloaded).
func _show_as_already_collected() -> void:
	# TODO(you): decide how an already-remembered fragment looks.
	pass


func _on_body_entered(body: Node3D) -> void:
	if grabbed or not body is Player:
		return
	grabbed = true

	GameState.collect_fragment(chapter_id, fragment_id)
	Audio.play("res://sounds/coin.ogg")

	$Mesh.queue_free()
	$Particles.emitting = false


func _process(delta: float) -> void:
	rotate_y(2 * delta)
	position.y += cos(time * 5) * delta
	time += delta
