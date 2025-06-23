extends Node2D
class_name SpaceShip

@export var game_controller: GameController

func _on_interact_area_body_entered(body: Node2D) -> void:
	print("Colidiu!");
	if body is Player:
		if body.is_with_component:
			var stage: String;
			match game_controller.actual_region:
				1:
					stage = "lv1";
				2:
					stage = "lv2";
				3:
					stage = "lv3";
				4:
					stage = "lv4";
			$Sprite.play(stage);
			$ArriveSound.play();
			game_controller.increment_region();
