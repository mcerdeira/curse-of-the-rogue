extends Node


var _current_track : AudioStreamPlayer


## Devuelve el AudioStream actual
func get_stream() -> AudioStream :
	return _current_track.stream


## Devuelve el resource path del AudioStream actual
func get_stream_as_string() -> String :
	if _current_track.stream is AudioStream:
		return _current_track.stream.resource_path
	else:
		return ""

## Devuelve true si se está reproduciendo un audio
func is_playing() -> bool:
	return is_instance_valid(_current_track) and _current_track.playing


## Reproduce el audio deseado, con crossfade opcional.
##
## - `path_or_audiostream`: Un path (String) o un AudioStream a reproducir.
## - `crossfade_duration`: Segundos de crossfade entre el audio actual y el nuevo.
func play( path_or_audiostream, crossfade_duration := 1.0 ):
	var new_track = _create_player(path_or_audiostream)
	if new_track.stream == _current_track and is_instance_valid(_current_track) and _current_track.stream_paused:
		_current_track.stream_paused = false
		return

	_stop_track(_current_track, crossfade_duration)
	_start_track(new_track, crossfade_duration)
	_current_track = new_track


## Pausa la reproducción del stream actual
func pause() -> void :
	_current_track.stream_paused = true


## Detiene la reproducción del stream actual
func stop(fade_duration := 1.0) -> void:
	_stop_track(_current_track, fade_duration)
	_current_track = null


func _create_player(path_or_audiostream) -> AudioStreamPlayer:
	var ret := AudioStreamPlayer.new()
	ret.bus = "Music"
	if path_or_audiostream is AudioStream:
		ret.stream = path_or_audiostream
	elif typeof(path_or_audiostream) == TYPE_STRING:
		var stream = load(path_or_audiostream)
		if stream is AudioStream:
			ret.stream = stream
		else:
			push_warning("Music singleton could not load %s" % path_or_audiostream)
	else:
		push_error("'path_or_audiostream' should be a path string or an AudioStream")
	return ret

func _start_track(track : AudioStreamPlayer, fade_duration := 1.0):
	if !track.stream:
		return

	add_child(track)
	track.play()
	if fade_duration > 0.0:
		track.volume_db = -60
		var tweener = get_tree().create_tween()
		tweener.tween_property(track, "volume_db", 0.0, fade_duration)


func _stop_track(track : AudioStreamPlayer, fade_duration := 1.0):
	if !is_instance_valid(track):
		return
	if fade_duration > 0.0:
		var tweener = get_tree().create_tween()
		tweener.tween_property(track, "volume_db", -60.0, fade_duration )
		tweener.tween_callback(track, "queue_free")
	else:
		track.queue_free()
