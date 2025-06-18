extends Projectile

func _ready() -> void:
	global_position = pos;
	global_rotation = rot;
	scale = Vector2(scl, scl);
	explosion = preload("res://Scenes/Components/explosion.tscn");

func _physics_process(delta: float) -> void:
	define_velocity();
	var collision = move_and_collide(velocity * delta);
	if collision && collision.get_collider().is_in_group("Walls"):
		destroy_and_explode();
