extends Node2D

signal component_picked;

var related_region: int;

func change_item(num: int) -> void:
	var item: String;
	match num:
		1:
			item = "wings";
		2:
			item = "battery";
		3:
			item = "control_core";
		4:
			item = "antenna";
	$Sprite.play(item);
	print("Item da region " + str(num) + " é: " + item);

func _on_collect_area_body_entered(body: Node2D) -> void:
	if body is Player:
		if !body.is_with_component:
			body.is_with_component = true;
			body.collected = true;
			print("Coletado!");
			queue_free();
