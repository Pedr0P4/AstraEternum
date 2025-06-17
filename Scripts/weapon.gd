extends Node2D
class_name Weapon

@export var related: Player;
@export var bullet: PackedScene;

func point(sprite: AnimatedSprite2D) -> void:
	var globalM_pos: Vector2 = get_global_mouse_position();
	var x_cap: float = abs(globalM_pos.y - related.position.y)*1.2;
	z_index = 1;
	if(globalM_pos.x < related.position.x + x_cap && globalM_pos.x > related.position.x - x_cap):
		sprite.play("Up_Down");
		sprite.flip_v = false;
		if globalM_pos.y < related.position.y:
			z_index = -1;
	else:
		sprite.play("Sides");
		sprite.rotate(0);
		if globalM_pos.x < related.position.x:
			sprite.flip_v = true;
		else:
			sprite.flip_v = false;

func fire(marker: Marker2D) -> void:
	var bullet_instance = bullet.instantiate();
	bullet_instance.dir = rotation;
	bullet_instance.pos = marker.global_position;
	bullet_instance.rot = rotation - PI/2;
	bullet_instance.scl = 1;
	get_tree().current_scene.add_child(bullet_instance);
