extends CharacterBody3D

const JUMP_VELOCITY = 6
@export var reload_speed = 3
@export var damage:float = 10.0
@export var speed = 4.0
@export var radius = 1.0

const mouse_sens = 0.00108
var look_dir = Vector3()
var prev_pos = Vector2()
@onready var neck := $Neck
@onready var camera: Camera3D = $Neck/FirstPersonCamera
@onready var bullet = preload("res://scenes/bullet.tscn")
var reloading = false
var sprint_avaliable = true
var in_air = false
var dead = false
var focused = true

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion && Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		neck.rotate_y(-event.relative.x * mouse_sens)
		camera.rotate_x(-event.relative.y * mouse_sens)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _physics_process(delta: float) -> void:
	if (!focused):
		if(Input.is_action_just_pressed("shoot")):
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			focused = true
	else:
		if(Input.is_action_just_pressed("unlock mouse")):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			focused = false
		if dead:
			velocity = Vector3(0,0,0)
		else:
			if (Input.is_action_pressed("shoot") && !reloading):
				shoot()
			# Add the gravity.
			if not is_on_floor():
				velocity += get_gravity() * delta

			# Handle jump.
			if(is_on_floor() && in_air == true):
				prev_pos = $"../NavigationRegion3D/Stage".translate_world_to_grid(position)
				in_air = false
			
			if Input.is_action_just_pressed("jump") and is_on_floor():
				velocity.y = JUMP_VELOCITY
				in_air=true


		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir := Input.get_vector("strafe left", "strafe right", "move forward", "move backward")
		var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if (Input.is_action_pressed("rapid_change_direction") && sprint_avaliable):
			velocity.x += direction.x * speed * delta * 100
			velocity.z += direction.z * speed * delta * 100
			sprint_avaliable = false
			$DashTimer.start()
		if direction:
			if (velocity.x>0 && direction.x<0):
				velocity.x += direction.x * speed * delta * 3
			else:
				velocity.x += direction.x * speed * delta
			if (velocity.z>0 && direction.z<0):
				velocity.z += direction.z * speed * delta * 3
			else:
				velocity.z += direction.z * speed * delta
		else:
			velocity.x = lerpf(velocity.x, 0, 0.01)
			velocity.z = lerpf(velocity.z, 0, 0.01)

		move_and_slide()
		for body in $Area3D.get_overlapping_bodies():
			if body.is_in_group("erasers"):
				$"../NavigationRegion3D/Stage".end = true
				dead = true
			if body.is_in_group("power"):
				var mod = body.modifier
				match body.type:
					"radius":
						radius+=0.5*mod
					"damage":
						damage+=2.5*mod
						reload_speed*=1.1
					"speed":
						speed+=0.5*mod
					"reload":
						reload_speed*=pow(0.9, mod)
				body.queue_free()
		if (position.y < 0):
			$"../NavigationRegion3D/Stage".end = true
			dead = true

func shoot() -> void:
	var bull = bullet.instantiate()
	bull.position = $Neck.global_position
	bull.speed = 10.0
	bull.direction = Vector3(0,0,-1).rotated(Vector3(1, 0, 0), camera.rotation.x).rotated(Vector3(0, 1, 0), neck.rotation.y)
	bull.added_velocity = velocity
	bull.damage = damage
	bull.radius = round(radius/2)
	$"../NavigationRegion3D/Stage/Bullets".add_child(bull)
	reloading = true
	$ReloadTimer.wait_time = reload_speed
	$ReloadTimer.start()
	
func _notification(what: int):
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		focused = false
		get_tree().paused = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if what == NOTIFICATION_APPLICATION_FOCUS_IN:
		focused = true
		get_tree().paused = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_reload_timer_timeout() -> void:
	reloading = false

func _on_dash_timer_timeout() -> void:
	sprint_avaliable = true
