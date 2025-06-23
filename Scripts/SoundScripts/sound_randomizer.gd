extends Node2D

signal sound_finished

@onready var sounds: Array = $Sounds.get_children();
var audios_amount: int;
var rng: RandomNumberGenerator;

func _ready() -> void:
	audios_amount = sounds.size();
	rng = RandomNumberGenerator.new();
	for i in range(audios_amount):
		sounds[i].finished.connect(_on_audio_finished);

func play_random_audio() -> void:
	var audio_index = rng.randi_range(0, audios_amount-1);
	sounds[audio_index].play();

func _on_audio_finished() -> void:
	sound_finished.emit();
