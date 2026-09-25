extends Control

var _fragment_total: int = 0


func _ready() -> void:
	# Siblings earlier in the tree (the World with its fragments) are ready
	# before the HUD, so the group is already populated here.
	_fragment_total = get_tree().get_nodes_in_group(MemoryFragment.GROUP).size()
	if _fragment_total == 0:
		return
	GameState.fragment_collected.connect(_on_fragment_collected)
	_refresh_fragments()


func _on_coin_collected(coins):

	$Coins.text = str(coins)


func _on_fragment_collected(chapter_id: StringName, _fragment_id: StringName) -> void:
	if chapter_id == GameState.current_chapter_id:
		_refresh_fragments()


func _refresh_fragments() -> void:
	$Coins.text = "%d / %d" % [GameState.fragment_count(GameState.current_chapter_id), _fragment_total]
