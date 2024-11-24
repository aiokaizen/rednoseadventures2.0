extends Area2D
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var box: CollisionShape2D = $Box
@onready var box_embed: CollisionShape2D = $BoxEmbed
@onready var box_spin: CollisionShape2D = $BoxSpin


func _on_body_entered(body: Node2D) -> void:
	sprite.play("collect")
	box.queue_free()
	body.has_sword = true


func _on_sprite_animation_finished() -> void:
	queue_free()
