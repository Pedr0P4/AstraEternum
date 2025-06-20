extends Node2D
class_name Weapon

@export var related: Player;
@export var bullet := preload("res://Scenes/Components/bullet.tscn")
var shooting: bool;

func point(sprite: AnimatedSprite2D) -> void:
	var globalM_pos: Vector2 = get_global_mouse_position();
	var x_cap: float = abs(globalM_pos.y - related.position.y)*1.2;
	if(globalM_pos.x < related.position.x + x_cap && globalM_pos.x > related.position.x - x_cap && !shooting):
		sprite.play("Up_Down");
		sprite.flip_v = false;
		if globalM_pos.y < related.position.y:
			z_index = -1;
	elif !shooting:
		z_index = 1;
		sprite.play("Sides");
		sprite.rotate(0);
		if globalM_pos.x < related.position.x:
			sprite.flip_v = true;
		else:
			sprite.flip_v = false;

func fire(marker: Marker2D) -> void:
	var bullet_instance = bullet.instantiate()
	var direction_to_mouse = (get_global_mouse_position() - marker.global_position).normalized()
	bullet_instance.direction = direction_to_mouse
	bullet_instance.position = marker.global_position
	get_tree().current_scene.add_child(bullet_instance)
