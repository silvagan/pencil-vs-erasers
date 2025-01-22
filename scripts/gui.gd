extends MarginContainer
@onready var end_screen = false
var stage = null
var player = null
var reload = null
var dash = null
var red = Color.RED.darkened(0.2)
var yellow = Color.YELLOW.darkened(0.2)
var green = Color.GREEN.darkened(0.2)

func _ready():
	var tree = get_tree()
	stage = tree.current_scene.get_node("/root/Scene/NavigationRegion3D/Stage")
	player = tree.current_scene.get_node("/root/Scene/Pencil")
	reload = tree.current_scene.get_node("/root/Scene/Pencil/ReloadTimer")
	dash = tree.current_scene.get_node("/root/Scene/Pencil/DashTimer")
func update():
	if end_screen:
		$EndStats.visible = true
		$Crosshair.visible = false
		var score = stage.score
		if score < 10:
			$EndStats/HBoxContainer/Label2.label_settings.font_color = red
		elif score < 50:
			$EndStats/HBoxContainer/Label2.label_settings.font_color = yellow
		else:
			$EndStats/HBoxContainer/Label2.label_settings.font_color = green
		$EndStats/HBoxContainer/Label2.text = str(round(score))
	else:
		var margin = round(stage.sum/(stage.grid_size.x*stage.grid_size.y)*100)
		$SceneInfo/Misc/CoverMargin/Label.text = str(margin)+"%"
		if margin > 60:
			$SceneInfo/Misc/CoverMargin/Label.label_settings.font_color = green
		var frames = Engine.get_frames_per_second()
		if frames > 166:
			$SceneInfo/Misc/Framerate.label_settings.font_color = green
		elif frames > 60:
			$SceneInfo/Misc/Framerate.label_settings.font_color = yellow
		else:
			$SceneInfo/Misc/Framerate.label_settings.font_color = red
		$SceneInfo/Misc/Framerate.text = str(Engine.get_frames_per_second())
		$SceneInfo/WaveIndicators/NextWaveCountdown/Data.text = str(snapped(stage.get_time_to_next_wave(), 0.01))
		$SceneInfo/WaveIndicators/CurrentWave/Data.text = stage.current_wave
		
		$PlayerStats/Value/Damage.text = str(player.damage)
		$PlayerStats/Value/ReloadSpeed.text = str(player.reload_speed)
		$PlayerStats/Value/Speed.text = str(player.speed)
		$PlayerStats/Value/Radius.text = str(player.radius)
		
		var rel:float = snapped(reload.time_left, 0.01)
		var dsh = snapped(dash.time_left, 0.01)
		if(rel == 0):
			$PlayerStats/Value/ReloadLeft.text = "ready"
		else:
			$PlayerStats/Value/ReloadLeft.text = str(rel)
		if(dsh == 0):
			$PlayerStats/Value/Dash.text = "ready"
		else:
			$PlayerStats/Value/Dash.text = str(dsh)
		
		var rel_margin:float = 100 - snapped(rel/reload.wait_time, 0.01)*100
		$Crosshair/VBoxContainer/TextureProgressBar.value = rel_margin
