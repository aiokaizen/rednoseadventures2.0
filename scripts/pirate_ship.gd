extends Node2D
@onready var animation_player: AnimationPlayer = $PirateShipPlatformShort1/PirateShipPlatformShort1Animation
@onready var area_2d: Area2D = $PirateShipPlatformShort1/Area2D

var location = 1  # 1: top; -1: bottom

func _on_area_2d_body_entered(_body: Node2D) -> void:
	if location == 1:
		animation_player.play("platform1_movements")
	else:
		animation_player.play_backwards("platform1_movements")


func _on_pirate_ship_platform_short_1_animation_animation_finished(anim_name: StringName) -> void:
	location = -location
