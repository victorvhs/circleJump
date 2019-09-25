extends Node

var score_file = "user://highscore.save"
var ads_file = "res://id.txt"
var settings_file = "user://settings.save"
var enable_sounds = true
var enable_music = true

var circles_per_level = 5

var color_schemes = {
    "NEON1": {
        'background': Color8(0, 0, 0),
        'player_body': Color8(203, 255, 0),
        'player_trail': Color8(204, 0, 255),
        'circle_fill': Color8(255, 0, 110),
        'circle_static': Color8(0, 255, 102),
        'circle_limited': Color8(204, 0, 255)
    },
    "NEON2": {
        'background': Color8(0, 0, 0),
        'player_body': Color8(246, 255, 0),
        'player_trail': Color8(255, 255, 255),
        'circle_fill': Color8(255, 0, 110),
        'circle_static': Color8(151, 255, 48),
        'circle_limited': Color8(127, 0, 255)
    },
    "NEON3": {
        'background': Color8(0, 0, 0),
        'player_body': Color8(255, 0, 187),
        'player_trail': Color8(255, 148, 0),
        'circle_fill': Color8(255, 148, 0),
        'circle_static': Color8(170, 255, 0),
        'circle_limited': Color8(204, 0, 255)
    },
	"User":{
        'background': Color8(0, 0, 0),
        'player_body': Color8(255, 0, 187),
        'player_trail': Color8(255, 148, 0),
        'circle_fill': Color8(255, 148, 0),
        'circle_static': Color8(170, 255, 0),
        'circle_limited': Color8(204, 0, 255)
    }
}
var op = "NEON1"
var theme = color_schemes[op]

static func rand_weighted(weights):
	var sum = 0
	for weight in weights:
		sum += weight
	var num = rand_range(0, sum)
	for i in weights.size():
		if num < weights[i]:
			return i
		num -= weights[i]
		

var admob = null
var real_ads = false
var banner_top = false
var ad_banner_id = get_id_ads()

func get_id_ads():
	var f = File.new()
	if f.file_exists(ads_file):
		f.open(ads_file,File.READ)
		return (str(f.get_as_text()))
		f.close()


func _ready():
	load_settings()
	if Engine.has_singleton("AdMob"):
		admob = Engine.get_singleton("AdMob")
		admob.init(real_ads, get_instance_id())
		admob.loadBanner(ad_banner_id, banner_top)
		
func show_banner():
	if admob:
		admob.showBanner()

func hide_ad_banner():
	if admob:
		admob.hideBanner()
		
func save_settings():
	var f = File.new()
	f.open(settings_file, File.WRITE)
	f.store_var(enable_music)
	f.store_var(enable_sounds)
	f.close()

func load_settings():
	var f = File.new()
	if f.file_exists(settings_file):
		f.open(settings_file,File.READ)
		enable_music = f.get_var()
		enable_sounds = f.get_var()
		f.close()
	
	
	
	
	
	
	
	
	