extends RigidBody3D
var type
var modifier:float = 1

func set_random_type() -> void:
	var types = ["radius", "damage", "speed", "reload"]
	type = types[randi_range(0,3)]
	var mat = StandardMaterial3D.new()
	var color
	match type:
		"radius":
			color = Color.LIGHT_SKY_BLUE
		"damage":
			color = Color.PALE_VIOLET_RED
		"speed":
			color = Color.LIGHT_YELLOW
		"reload":
			color = Color.LIGHT_GREEN
	mat.albedo_color = color.darkened(modifier/10)
	$MeshInstance3D.material_override = mat
	$Label3D.text = type
	for i in modifier:
		$Label3D.text += "+"
