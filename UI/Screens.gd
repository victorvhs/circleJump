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
		match btn.name:
			"Sound":
				btn.texture_normal = sound_buttons[settings.enable_sounds]
			"Music":
				btn.texture_normal = music_buttons[settings.enable_music]

func  _on_button_pressed(btn):
	if settings.enable_sounds:
		$Click.play()
	match btn.name:
		"About":
			change_screen($AboutScreen)
			print("About")
		"Home":
			change_screen($TitleScreen)
			settings.show_banner()
		"Play":
			change_screen(null)
			yield(get_tree().create_timer(0.5),"timeout")
			emit_signal("start_game")
			settings.hide_ad_banner()
		"Settings":
			change_screen($SettingsScreen)
			settings.show_banner()
		"Sound":
			settings.enable_sounds = !settings.enable_sounds
			btn.texture_normal = sound_buttons[settings.enable_sounds]
			settings.save_settings()
		"Music":
			settings.enable_music = !settings.enable_music
			btn.texture_normal = music_buttons[settings.enable_music]
			settings.save_settings()
		"Color":
			change_screen($Color)
			settings.show_banner()
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
		
func game_over(score, best, level):
	var score_box = $GameOverScreen/MarginContainer/VBoxContainer/Score
	score_box.get_node("Score").text = "Score: %s" % str(score)
	score_box.get_node("Best").text = "Best: %s" % str(best)
	score_box.get_node("Level").text = "Level: %s" % str(level)
	change_screen($GameOverScreen)