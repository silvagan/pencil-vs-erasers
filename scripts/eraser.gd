extends CharacterBody3D

var player = null
var stage = null
const SPEED = 5.0
var HPmax = 100.0
var HP = 100.0
var prev_pos = Vector2()
var pos = Vector2()
var behaviour: String = "spiral"
var dead = false

@export var radius = 8 #spiral stops working if radius is not scaled together with pixel resolution
@onready var nav_agent = $NavigationAgent3D

func _ready() -> void:
	set_physics_process(false)
	call_deferred("actor_setup")
	var tree = get_tree()
	player = tree.current_scene.get_node("/root/Scene/Pencil")
	stage = tree.current_scene.get_node("/root/Scene/NavigationRegion3D/Stage")
	
	var mat = StandardMaterial3D.new() #Make a new Spatial Material
	match behaviour:
		"idle":
			mat.albedo_color = Color.SKY_BLUE.lightened(0.3) #Set color of new material
			HPmax = 20
			HP = 20
		"chase":
			mat.albedo_color = Color.RED.lightened(0.3) #Set color of new material
			HPmax = 50
			HP = 50
		"spiral":
			mat.albedo_color = Color.AQUAMARINE.lightened(0.3) #Set color of new material
			HPmax = 100
			HP = 100
	$MeshInstance3D.material_override = mat #Assign new material to material overrride

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	velocity = Vector3.ZERO
	match behaviour:
		"chase":
			if(!player.dead):
				nav_agent.set_target_position(player.global_transform.origin)
		"idle":
			if(nav_agent.is_navigation_finished()):
				behaviour = "wait"
				nav_agent.set_target_position(position + Vector3(randf_range(-20, 20), 0, randf_range(-20, 20)))
		"spiral":
			if(nav_agent.is_navigation_finished()):
				var target = stage.spiral_closest(position)
				if(target != Vector3.ZERO):
					nav_agent.set_target_position(Vector3(target.x, target.y, target.z))
					#print("navigating to new target: " + str(target)+ "from position: " + str(position))
		"wait":
			await get_tree().create_timer(randf_range(3, 10)).timeout
			behaviour = "idle"
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * SPEED * delta * 60
	move_and_slide()
	pass
	
var states = {"idle":1, "wait":1, "chase":2, "spiral":3}
func take_damage(value):
	HP -= value
	set_color(1-HP/HPmax)
	if HP <= 0 && !dead:
		dead = true
		queue_free()
		stage.spawn_power_up(position, states[behaviour])

func set_color(modifier):
	var newMaterial = StandardMaterial3D.new() #Make a new Spatial Material
	match behaviour:
		"chase":
			newMaterial.albedo_color = Color.RED.darkened(modifier) #Set color of new material
		"idle", "wait":
			newMaterial.albedo_color = Color.SKY_BLUE.darkened(modifier) #Set color of new material
		"spiral":
			newMaterial.albedo_color = Color.AQUAMARINE.darkened(modifier) #Set color of new material
	$MeshInstance3D.material_override = newMaterial #Assign new material to material overrride
