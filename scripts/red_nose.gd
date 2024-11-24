extends CharacterBody2D

@onready var player_box: CollisionShape2D = $PlayerBox
@onready var player_sprite: AnimatedSprite2D = $PlayerSprite

const SPEED = 200.0
const JUMP_VELOCITY = -350.0
const WALL_JUMP_VELOCITY = -280.0
var is_dead = false
var can_double_jump = true
var jump_count = 0
var airborn = false
var jumping = false
var falling = false


func die():
	is_dead = true
	player_sprite.play("die")


func _physics_process(delta: float) -> void:
	var x_velocity = 0
	
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
	
	if falling:
		player_sprite.play("fall")
	
	if direction:
		# Change player direction
		player_sprite.flip_h = false if direction > 0 else true
	
	# Handle floor animations
	if not airborn:
		if direction:
			# Player is moving
			player_sprite.play("run")
			
		else:
			# Player is idle
			player_sprite.play("idle")
	
	if direction:
		velocity.x = x_velocity + (direction * SPEED)
		if x_velocity:
			print("x_velocity:", str(x_velocity))
			print("Normal velocity:", str(direction * SPEED))
			print("final velocity:", str(velocity.x))
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
