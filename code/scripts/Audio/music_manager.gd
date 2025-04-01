extends Node


@export var audio_stream_player: AudioStreamPlayer


func _ready() -> void:
	# using autoplay results in "null function or function signature mismatch" in web
	# godot issue: https://github.com/godotengine/godot/issues/104645
	audio_stream_player.play()


func switch_music(music_name: StringName) -> void:
	var interactive_stream: AudioStreamInteractive = audio_stream_player.get_stream()
	var intereactive_playback: AudioStreamPlaybackInteractive = audio_stream_player.get_stream_playback()
	var current_music_name: StringName = interactive_stream.get_clip_name(intereactive_playback.get_current_clip_index())

	if current_music_name == music_name:
		return

	intereactive_playback.switch_to_clip_by_name(music_name)
