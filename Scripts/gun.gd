extends Weapon

var can_shoot: bool;

func _ready() -> void:
	can_shoot = true;

func _process(delta: float) -> void:
	point($Sprite);
	if Input.is_action_just_pressed("click") && can_shoot:
		if $Sprite.animation == "Up_Down":
			$Sprite.stop();
			shooting = true;
			$Sprite.play("UpDown_shooting");
		elif $Sprite.animation == "Sides":
			$Sprite.stop();
			shooting = true;
			$Sprite.play("Sides_shooting");
		fire($Position);
		can_shoot = false;
		$ShootCD.start();

func _on_shoot_cd_timeout() -> void:
	can_shoot = true;

func _on_sprite_animation_finished() -> void:
	if $Sprite.animation != "Sides" && $Sprite.animation != "Up_Down":
		shooting = false;
