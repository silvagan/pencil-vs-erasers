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
	$HBoxContainer/VBoxContainer/MarginContainer/Label.text = "0%"
func update():
	if end_screen:
		$VBoxContainer.visible = true
		$HCrosshair.visible = false
		var score = stage.score
		if score < 10:
			$VBoxContainer/HBoxContainer/Label2.label_settings.font_color = red
		elif score < 50:
			$VBoxContainer/HBoxContainer/Label2.label_settings.font_color = yellow
		else:
			$VBoxContainer/HBoxContainer/Label2.label_settings.font_color = green
		$VBoxContainer/HBoxContainer/Label2.text = str(round(score))
	else:
		var margin = round(stage.sum/(stage.grid_size.x*stage.grid_size.y)*100)
		$HBoxContainer/VBoxContainer/MarginContainer/Label.text = str(margin)+"%"
		if margin > 60:
			$HBoxContainer/VBoxContainer/MarginContainer/Label.label_settings.font_color = green
		var frames = Engine.get_frames_per_second()
		if frames > 166:
			$HBoxContainer/VBoxContainer/Label2.label_settings.font_color = green
		elif frames > 60:
			$HBoxContainer/VBoxContainer/Label2.label_settings.font_color = yellow
		else:
			$HBoxContainer/VBoxContainer/Label2.label_settings.font_color = red
		$HBoxContainer/VBoxContainer/Label2.text = str(Engine.get_frames_per_second())
		$HBoxContainer/VBoxContainer2/HBoxContainer2/Label2.text = str(snapped(stage.get_time_to_next_wave(), 0.01))
		$HBoxContainer/VBoxContainer2/HBoxContainer/Label2.text = stage.current_wave
		
		$HBoxContainer3/VBoxContainer2/Value.text = str(player.damage)
		$HBoxContainer3/VBoxContainer2/Value2.text = str(player.reload_speed)
		var rel:float = snapped(reload.time_left, 0.01)
		var rel_margin:float = 100 - snapped(rel/reload.wait_time, 0.01)*100
		var dsh = snapped(dash.time_left, 0.01)
		$HCrosshair/VCrosshair/Crosshair.value = rel_margin
		if(rel == 0):
			$HBoxContainer3/VBoxContainer2/Value3.text = "ready"
		else:
			$HBoxContainer3/VBoxContainer2/Value3.text = str(rel)
		$HBoxContainer3/VBoxContainer2/Value4.text = str(player.speed)
		if(dsh == 0):
			$HBoxContainer3/VBoxContainer2/Value5.text = "ready"
		else:
			$HBoxContainer3/VBoxContainer2/Value5.text = str(dsh)
		$HBoxContainer3/VBoxContainer2/Value6.text = str(player.radius)
