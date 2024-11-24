extends Node2D

@onready var candle_light: AnimatedSprite2D = $CandleLight
var rand = RandomNumberGenerator.new()


func _ready() -> void:
	var choices = [0, PI / 2, PI, 3 * PI / 2, 2 * PI]
	candle_light.rotate(choices[rand.randi_range(0, 3)])
