extends Area2D
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var box: CollisionShape2D = $Box


func _on_body_entered(_body: Node2D) -> void:
	sprite.play("collect")
	box.queue_free()


func _on_sprite_animation_finished() -> void:
	queue_free()
