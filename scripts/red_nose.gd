extends CharacterBody2D

@onready var player_box: CollisionShape2D = $PlayerBox
@onready var sprite_without_sword: AnimatedSprite2D = $WithoutSword
@onready var sprite_with_sword: AnimatedSprite2D = $WithSword
@onready var player_sprite = sprite_without_sword
@onready var attack_01_box: CollisionPolygon2D = $Attack01Box
@onready var attack_02_box: CollisionPolygon2D = $Attack02Box
@onready var attack_03_box: CollisionPolygon2D = $Attack03Box
@onready var air_attack_01_box: CollisionPolygon2D = $AirAttack01Box
@onready var air_attack_02_box: CollisionPolygon2D = $AirAttack02Box

const SPEED = 200.0
const JUMP_VELOCITY = -350.0
const WALL_JUMP_VELOCITY = -280.0
var is_dead = false
var can_double_jump = true
var jump_count = 0
var airborn = false
var jumping = false
var falling = false
var has_sword = false
var is_attacking = false


func die():
	is_dead = true
	player_sprite.play("die")


func _physics_process(delta: float) -> void:
	var x_velocity = 0
	
	if has_sword:
		sprite_without_sword.hide()
		player_sprite = sprite_with_sword
		player_sprite.visible = true
	else:
		sprite_with_sword.hide()
		player_sprite = sprite_without_sword
		player_sprite.visible = true
	
	# Handle death scenario
	if is_dead:
		if velocity.y < 0:
			velocity.y = 0
		if not is_on_floor():
			velocity += get_gravity() * delta
		velocity.x = move_toward(velocity.x, 0, SPEED)
		move_and_slide()
		return
	
	# Handle airborn state
	if not is_on_floor():
		airborn = true
		velocity += get_gravity() * delta
		if velocity.y > 0 and not falling:
			falling = true
			jumping = false
	else:
		jump_count = 0
		airborn = false
		falling = false
		jumping = false
	
	var direction := Input.get_axis("move_left", "move_right")
	
	if Input.is_action_just_pressed("attack") and has_sword:
		if not airborn:
			player_sprite.play("attack_02")
			attack_02_box.disabled = false
		else:
			player_sprite.play("air_attack_02")
			air_attack_02_box.disabled = false
		is_attacking = true
	
	if Input.is_action_just_pressed("throw_sword"):
		# Throw sword
		pass
	
	if Input.is_action_just_pressed("jump"):
		# Handle normal jump.
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			jump_count += 1
			jumping = true
			airborn = true
			player_sprite.play("jump")
	
		# Handle wall jump.
		elif is_on_wall() and direction != 0:
			velocity.y = WALL_JUMP_VELOCITY
			#x_velocity += -direction * SPEED * 2  # Push the char away from the wall.
			jump_count = 1
			jumping = true
			airborn = true
			falling = false
			player_sprite.play("jump")
		elif jump_count < 2:
			# Handle double jump
			velocity.y = JUMP_VELOCITY
			jump_count += 1
			jumping = true
			falling = false
			player_sprite.play("jump")
	
	if falling and not is_attacking:
		player_sprite.play("fall")
	
	if direction:
		# Change player direction
		player_sprite.flip_h = false if direction > 0 else true
	
	# Handle floor animations
	if not airborn and not is_attacking:
		if direction:
			# Player is moving
			player_sprite.play("run")
		else:
			# Player is idle
			player_sprite.play("idle")
	
	if direction:
		velocity.x = x_velocity + (direction * SPEED)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()


func _on_with_sword_animation_finished() -> void:
	if is_attacking:
		is_attacking = false
		attack_02_box.disabled = true
		air_attack_02_box.disabled = true
