extends BoxContainer

var amount: int = 2;

func _ready() -> void:
	if amount > 2:
		amount = 2;
	$Sprite.frame = amount;

func update_life() -> void:
	$Sprite.frame = amount;

func lose(damage) -> void:
	var total = damage - amount;
	if total > 0:
		amount = 0
		update_life()
	elif total < 0:
		amount -= damage;
		update_life();
	else:
		amount = 0;
		update_life();
