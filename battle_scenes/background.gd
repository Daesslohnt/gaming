extends AudioStreamPlayer

func _ready():
	# Setzen Sie das Signal "finished" auf die Methode "_on_audio_finished"
	connect("finished", self, "_on_audio_finished")

func _on_audio_finished():
	# Diese Methode wird aufgerufen, wenn das Audio abgeschlossen ist
	# Starten Sie das Audio erneut, um es im Loop abzuspielen
	play()

# Beispiel für das Starten des Audio-Loops
func start_audio_loop():
	play()

# Beispiel für das Stoppen des Audio-Loops
func stop_audio_loop():
	stop()

