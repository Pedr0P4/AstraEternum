extends Weapon

var can_shoot: bool;

func _ready() -> void:
	can_shoot = true;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	point($Sprite);
	if Input.is_action_just_pressed("click") && can_shoot:
		fire($Position);
		can_shoot = false;
		$ShootCD.start();

func _on_shoot_cd_timeout() -> void:
	can_shoot = true;
