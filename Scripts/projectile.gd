extends CharacterBody2D
class_name Projectile

var speed = 500;
var pos: Vector2;
var rot: float;
var dir: float;
var scl: float;
var explosion: PackedScene;

func destroy_projectile_outside_scene() -> void:
	if(
		global_position.x > get_viewport_rect().size.x ||
		global_position.x < 0 ||
		global_position.y > get_viewport_rect().size.y ||
		global_position.y < 0
		):
			queue_free();

func destroy_and_explode() -> void:
	queue_free();
	var explosion_instance = explosion.instantiate();
	explosion_instance.global_position = global_position;
	get_parent().add_child(explosion_instance);

func define_velocity() -> void:
	velocity = Vector2(speed, 0).rotated(dir);
