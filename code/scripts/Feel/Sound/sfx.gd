extends FeelComponent
class_name Sfx


@export var audio_bus: String
@export_range(0, 1) var volume: float = 1
@export var stream: AudioStream


func append_tween(_feel_player: FeelPlayer, _tween: Tween) -> void:
	var root: Node = _feel_player.get_tree().root
	var audio_player: AudioStreamPlayer = AudioStreamPlayer.new()
	audio_player.bus = audio_bus
	audio_player.volume_db = linear_to_db(volume)
	audio_player.stream = stream
	audio_player.finished.connect(audio_player.queue_free)

	root.add_child(audio_player)
	_tween.tween_callback(audio_player.play)
