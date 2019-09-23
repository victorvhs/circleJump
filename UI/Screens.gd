extends Node

signal start_game

var sound_buttons = { true: preload("res://assets/images/buttons/audioOn.png"),
					false: preload("res://assets/images/buttons/audioOff.png")}
var music_buttons = { true: preload("res://assets/images/buttons/musicOn.png"),
					false: preload("res://assets/images/buttons/musicOff.png")}

var current_screen = null

func _ready():
	register_buttons()
	change_screen($TitleScreen)

func register_buttons():
	var buttons = get_tree().get_nodes_in_group("buttons")
	for btn in buttons:
		btn.connect("pressed",self, "_on_button_pressed",[btn])

func  _on_button_pressed(btn):
	if settings.enable_sounds:
		$Click.play()
	match btn.name:
		"Home":
			change_screen($TitleScreen)
		"Play":
			change_screen(null)
			yield(get_tree().create_timer(0.5),"timeout")
			emit_signal("start_game")
		"Settings":
			change_screen($SettingsScreen)
		"Sound":
			settings.enable_sounds = !settings.enable_sounds
			btn.texture_normal = sound_buttons[settings.enable_sounds]
		"Music":
			settings.enable_music = !settings.enable_music
			btn.texture_normal = music_buttons[settings.enable_music]
		"Color":
			change_screen($Color)
		"NEON1":
			settings.op = "NEON1"
		"NEON2":
			settings.op = "NEON2"
		"NEON3":
			settings.op = "NEON3"
			
			
			
func change_screen(new_screen):
	if current_screen:
		current_screen.disappear()
		yield(current_screen.tween, "tween_completed")
	current_screen = new_screen
	if new_screen:
		current_screen.appear()
		yield(current_screen.tween, "tween_completed")
		
func game_over(score, best):
	var score_box = $GameOverScreen/MarginContainer/VBoxContainer/Score
	score_box.get_node("Score").text = "Score: %s" % str(score)
	score_box.get_node("Best").text = "Best: %s" % str(best)
	change_screen($GameOverScreen)