extends Area2D
class_name MusicTrigger


export (int) var song: int = 0


func _on_Music_trigger_body_entered(body: Player):
	if body:
		MusicPlayer.play_song(song)
