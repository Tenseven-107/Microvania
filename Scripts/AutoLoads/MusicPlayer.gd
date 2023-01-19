extends Node



enum themes {
	CRASHLANDED,
	BLUEPLANET,
	GOLDENGRASS
}


var tracks = {
	themes.CRASHLANDED: [preload("res://SFX/Music/Crash_Landed-Tenseven.mp3")],
	themes.BLUEPLANET: [preload("res://SFX/Music/Blue_Planet-Tenseven.mp3")],
	themes.GOLDENGRASS: [preload("res://SFX/Enemies/Enemy_death.wav")]
}


var current_theme: int = themes.CRASHLANDED
var is_repeating: bool = true

var music: AudioStreamPlayer


# Set up
func _ready():
	var m = AudioStreamPlayer.new()
	music = m
	music.bus = "Music"

	add_child(m)

	music.connect("finished", self, "repeat_song")


# Play song
func play_song(theme: int, repeat: bool = true):
	if current_theme != theme or !music.playing:
		is_repeating = false

		music.stop()

		is_repeating = repeat
		current_theme = theme

		var theme_tracks: Array = tracks[current_theme]
		if theme_tracks != []:
			music.stream = theme_tracks[randi() % theme_tracks.find(0)]
			music.play()



# Repeat song
func repeat_song():
	if is_repeating:
		var theme_tracks: Array = tracks[current_theme]
		music.stream = theme_tracks[randi() % theme_tracks.find(0)]
		music.play()



