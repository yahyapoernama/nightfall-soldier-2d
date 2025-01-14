extends AudioStreamPlayer2D

func _ready():
	var music = load("res://assets/sound/BGM-Menu.mp3")
	
	# Aktifkan looping pada stream
	music.loop = true
	
	# Set stream ke AudioStreamPlayer2D
	stream = music
	
	# Atur volume (dalam dB, misalnya -10 untuk volume lebih rendah)
	#volume_db = -10
	
	# Mulai memutar musik
	play()
