extends Node
class_name GameController

@export var player: Player;
@export var lifes: Lifes;
@export var spaceship: SpaceShip
@export var component: PackedScene;
var actual_region: int;
var levels : Array[Node];

func _ready() -> void:
	actual_region = 1;
	levels = get_tree().current_scene.get_node("Levels").get_children();
	player.damage_taken.connect(_on_player_damaged);
	lifes.player_died.connect(_on_player_died);

func _process(delta: float) -> void:
	if player.collected:
		change_itens();
		player.collected = false;

func increment_region() -> void:
	if actual_region == 4:
		$VictoryTimer.start();
	actual_region += 1;
	if player.is_with_component:
		player.is_with_component = false;

func change_itens() -> void:
	for i in range(levels.size()):
		if levels[i].item_inst:
			levels[i].item_inst.change_item(actual_region+1);

func _on_player_damaged(amount: int) -> void:
	lifes.take_damage(amount);

func _on_player_died() -> void:
	$DeathSound.play();
	$LoseTimer.start();
	player.player_collider.disabled = true;
	player.is_dead = true;
	if player.laser_gun:
		player.laser_gun.queue_free();

func _on_lose_timer_timeout() -> void:
	$GameSong.stop();
	get_tree().change_scene_to_file("res://Scenes/game_over.tscn");

func _on_victory_timer_timeout() -> void:
	$GameSong.stop();
	get_tree().change_scene_to_file("res://Scenes/victory.tscn");
