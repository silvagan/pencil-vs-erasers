extends RigidBody3D
var speed = 30.0
var direction = Vector2()
var lifetime = 5.0
var added_velocity = 0
var damage: float = 10.0
var on_ground:bool = false
@onready var prev_pos = Vector2()
var radius = 1
var stage
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(direction)
	linear_velocity = (direction) * speed * 20/damage + added_velocity
	var tree = get_tree()
	stage = tree.current_scene.get_node("/root/Scene/NavigationRegion3D/Stage")
	update_size()
	await get_tree().create_timer(lifetime).timeout
	stage.bullet_explode(stage.translate_world_to_grid(position), radius+damage/10)
	queue_free()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("erasers"):
		var damage_left = clamp(damage - body.HP, 0, 100)
		body.take_damage(damage)
		print("damaged " + str(body))
		damage = damage_left
		if damage == 0:
			queue_free()
		update_size()
	if body.is_in_group("ground"):
		print("onground")
		radius += round(damage/40)
		on_ground = true

func update_size()->void:
	var new_scale = damage/40+0.2
	var vec = Vector3(new_scale,new_scale,new_scale)
	$MeshInstance3D.scale = vec
	$CollisionShape3D.scale = vec
	$Area3D.scale = vec
