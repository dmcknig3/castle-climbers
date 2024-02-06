extends CharacterBody2D

@export var speed = 100
@export var gravity = 200
@export var jump_height = -100
var is_attacking = false
var is_climbing = false

func _physics_process(delta):
	#vertical movement down
	velocity.y = gravity * delta
	#horizontal left and right
	horizontal_movement()
	if !is_attacking:
		player_animations()
		
	player_animations()
	#applied movement
	move_and_slide()
	
func _input(event):
	#on attack
	if event.is_action_pressed("ui_attack"):
		is_attacking = true
		$AnimatedSprite2D.play("attack")
	
	#on jump
	if event.is_action_pressed("ui_jump") and is_on_floor():
		velocity.y = jump_height
		$AnimatedSprite2D.play("jump")
		
	#on climbing ladders
	if is_climbing == true:
		if Input.is_action_pressed("ui_up"):
			$AnimatedSprite2D.play("climb")
			gravity = 100
			velocity.y = -200
		#reset gravity
		else:
			gravity = 200
			is_climbing = false
		
func player_animations():
	#on left (add is_action_just_released so you continue running after jumping)
	if Input.is_action_pressed("ui_left") || Input.is_action_just_released("ui_jump"):
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("run")
		$CollisionShape2D.position.x = 7
	
	#on right
	if Input.is_action_pressed("ui_right") || Input.is_action_just_released("ui_jump"):
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("run")
		$CollisionShape2D.position.x = -7
		
	if !Input.is_anything_pressed():
		$AnimatedSprite2D.play("idle")
	

func horizontal_movement():
	# returns 1 for ui_right and -1 for ui_left
	var horizontal_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.x = horizontal_input * speed
	
func _on_animated_sprite_2d_animation_finished(): #signal from node inspector
	#reset attacking animation
	is_attacking = false
