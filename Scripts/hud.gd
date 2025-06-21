extends CanvasLayer

@onready var life_label := $HBoxContainer/LifeLabel


func _on_player_health_updated(current_health):
	life_label.text = str(current_health)
