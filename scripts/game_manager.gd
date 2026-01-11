extends Node

var score = 0
@onready var score_label: Label = $"../Hud/UI/ScoreLabel"


func add_point():
	score += 1
	score_label.text =  str(score) + " Coins"

var baby_mode: bool = false
var checkpoint_position: Vector2 = Vector2.ZERO
var has_checkpoint: bool = false

func set_baby_mode(enabled: bool) -> void:
	baby_mode = enabled
	print("Baby Mode:", baby_mode)

func set_checkpoint(pos: Vector2) -> void:
	checkpoint_position = pos
	has_checkpoint = true
	print("Checkpoint set:", checkpoint_position)

func clear_checkpoint() -> void:
	has_checkpoint = false
	checkpoint_position = Vector2.ZERO
