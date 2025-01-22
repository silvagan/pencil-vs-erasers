extends MeshInstance3D

@export var grid_size = Vector2(200,200)
var pixel_size
var level_size : float 
var grid=[]

@onready var lethality:float = 3
var lethality_increment = 1

var invulnurable = true

@onready var player = $"../../Pencil"
@onready var GUI = $"../../GUI"
const ERASER = preload("res://scenes/eraser.tscn")
const POWER = preload("res://scenes/power_up.tscn")

var sum = 0
@onready var score: float = 0.0

var pixel_count = grid_size.x*grid_size.y
var damage_from_pixel:float = 10*100/pixel_count

var texture : ImageTexture = ImageTexture.new()
var image : Image = Image.new()
var current_wave = ""

var end:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pixel_size = mesh.size.x/grid_size.x
	level_size = 50-pixel_size
	player.prev_pos = translate_world_to_grid(player.position)
	$Canvas.pixel_size = mesh.size.x/grid_size.x
	$Canvas.texture = texture
	initialize_grid(false)	
	current_wave = generate_wave()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("force restart"):
		get_tree().reload_current_scene()
		return
	if invulnurable:
		end = false
		$"../../Pencil".dead = false
		
	if end:
		GUI.end_screen = true
		GUI.update()
		$"../../WaveTimer".stop()
		if(Input.is_action_just_pressed("restart")):
			get_tree().reload_current_scene()
		
	else:
		if (!player.in_air):
			draw_on_canvas(player)
		if(Input.is_action_just_pressed("+radius")):
			player.radius += 1
		if(Input.is_action_just_pressed("-radius")):
			player.radius -= 1
		if(Input.is_action_just_pressed("spawn wave")):
			$"../../WaveTimer".emit_signal("timeout")
		var margin = sum/(grid_size.x*grid_size.y)*100
		score += pow(margin, 2)/100*delta
		GUI.update()
		
	for eraser in $Erasers.get_children():
		erase_from_canvas(eraser)
		
	for bullet in $Bullets.get_children():
		if(bullet.on_ground):
			bullet.prev_pos = translate_world_to_grid(bullet.position)
			draw_on_canvas(bullet)
	#print(sum)

func draw_on_canvas(object):
	var translated = translate_world_to_grid(object.position)
	draw_line(object.prev_pos, translated, false, object)
	object.prev_pos = translated

func erase_from_canvas(object):
	var translated = translate_world_to_grid(object.position)
	#print(translated)
	draw_line(object.prev_pos, translated, true, object)
	object.prev_pos = translated

func draw_line(strt_coord : Vector2, end_coord : Vector2, inverse: bool, object):
	for i in 4:
		var step = lerp(strt_coord, end_coord, 0.1*i)
		draw_rect(step, inverse, object)

func draw_rect(coord, inverse, object):
	if object.radius ==1:
		draw_dot(coord, inverse, object)
	else:
		for i in object.radius:
			for j in object.radius:
				draw_dot(coord + Vector2(i-object.radius/2, j-object.radius/2), inverse, object)

func bullet_explode(coord, radius):
	if radius ==1:
		draw_dot(coord, false, player)
	else:
		for i in radius:
			for j in radius:
				draw_dot(coord + Vector2(i-radius/2, j-radius/2), false, player)

func draw_dot(coord, inverse, object):
	if (coord.x >= grid_size.x || coord.y >= grid_size.y || coord.x < 0 || coord.y < 0):
		return
	if (inverse):
		if (grid[coord.x][coord.y] != 0):
			grid[coord.x][coord.y] = 0
			image.set_pixel(coord.x,coord.y, Color.TRANSPARENT)
			sum -=1
			object.take_damage(damage_from_pixel)
	elif (grid[coord.x][coord.y] != 1):
		grid[coord.x][coord.y] = 1
		image.set_pixel(coord.x,coord.y, Color.BLACK)
		sum +=1

func spiral_closest(start) -> Vector3:
	if(sum < 5):
		return Vector3.ZERO
	var translated = translate_world_to_grid(start)
	var visited = 1
	var rows = grid.size()
	var cols = grid[0].size()

	# Start at the given coordinate
	var x = translated.x
	var y = translated.y

	var directions = [Vector2(1, 0), Vector2(0, 1), Vector2(-1, 0), Vector2(0, -1)]
	var layer_size = 1
	var direction_index = 0
	
	while visited < rows * cols:
		for step in range(layer_size):
			x += directions[direction_index].x
			y += directions[direction_index].y
			
			if x < 0 or x >= rows or y < 0 or y >= cols:
				continue

			if(grid[x][y] == 1):
				return translate_grid_to_world(Vector2(x,y))
			visited += 1
			
		direction_index = (direction_index + 1) % 4
		if direction_index == 0 or direction_index == 2:
			layer_size += 1

	return Vector3.ZERO

func translate_world_to_grid(input: Vector3) -> Vector2:
	return round((Vector2(input.x, input.z) / level_size + Vector2(0.5, 0.5)) * (grid_size.x-1))

func translate_grid_to_world(input: Vector2) -> Vector3:
	return (Vector3(input.x, 0, input.y) / (grid_size.x-1) - Vector3(0.5, 0, 0.5)) * level_size + Vector3(0,1,0)
	
func initialize_grid(fill:bool):
	for x in range(grid_size.x):
		grid.append([])
		for y in range(grid_size.y):
			grid[x].append([])
			grid[x][y]=int(fill)
	image = Image.create(grid_size.x, grid_size.y, false, Image.FORMAT_RGBA8)  # Create an image
	image.fill(Color.TRANSPARENT)
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			if (grid[x][y] == 1):
				var color = Color.BLACK
				image.set_pixel(x, y, color)
	texture=ImageTexture.create_from_image(image)
	$Canvas.texture = texture

func spawn_eraser(pos: Vector3, behaviour: String) -> void:
	var er = ERASER.instantiate()
	er.position = pos
	er.prev_pos = translate_world_to_grid(pos)
	er.behaviour = behaviour
	$Erasers.add_child(er)

func random_location() -> Vector3:
	for i in 4:
		var loc = Vector3(randf_range(level_size/2, -level_size/2),1.0,randf_range(level_size/2, -level_size/2))
		if (loc.distance_to(player.position) > 10):
			return loc
	return Vector3.ZERO
	
func bulk_spawn(count:int, type:String) -> void:
	for i in count:
		var loc = random_location()
		if (loc != Vector3.ZERO):
			spawn_eraser(random_location(), type)
		
func spawn_power_up(location: Vector3, modifier):
	var p_up = POWER.instantiate()
	p_up.position = location
	p_up.position.y = 2
	p_up.modifier = modifier
	p_up.set_random_type()
	$Powerups.add_child(p_up)

func generate_wave() -> String:
	var types = ["idle", "chase", "spiral"]
	var wave = "";
	var index = randi_range(1,3)
	var count = floor(lethality/index)
	if(count>0):
		wave+= str(count)+" x "+types[index-1]
		bulk_spawn(count,types[index-1])
		lethality -= count * (index-1)
		$"../../WaveTimer".wait_time = 20 + 3 * count + 2 * index
		$"../../WaveTimer".start()
	else:
		wave = "free"
		$"../../WaveTimer".wait_time = 10
		$"../../WaveTimer".start()
	lethality_increment+=1
	return wave
	
func get_time_to_next_wave():
	return $"../../WaveTimer".time_left
	
func _on_wave_timer_timeout() -> void:
	lethality += lethality_increment
	lethality_increment+=0.5
	current_wave = generate_wave()
	invulnurable = true
	$"../../InvulnurableTimer".start()

func _on_invulnurable_timer_timeout() -> void:
	invulnurable = false

func _on_texture_update_timer_timeout() -> void:
	texture=ImageTexture.create_from_image(image)
	$Canvas.texture = texture
