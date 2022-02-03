extends KinematicBody2D

const GRAVITY = 500
const RUN_ACCEL = 400
const MAX_SPEED = 100
const JUMP_HEIGHT = -180
var velocity = Vector2.ZERO
var run_speed = 0
var jump_count = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var d = get_direction()
	if is_on_floor():
		jump_count = 0
	if d.y != 0 && jump_count < 2:
		print("direction, ", d, "jump_count", jump_count)
	
	if d == Vector2.ZERO && is_on_floor():
		$AnimatedSprite.animation = "idle"
	if velocity.y > 0 && !is_on_floor():
		$AnimatedSprite.animation = "fall"
	if d.x == 0:
		velocity.x = 0
		run_speed = 0
	else:
		run_speed += RUN_ACCEL * delta
		run_speed = clamp(run_speed, 0,  MAX_SPEED)	
		velocity.x = run_speed * d.x
	
	if d.y != 0 and (is_on_floor() or jump_count < 2):
		$AnimatedSprite.animation = "jump"
		if velocity.y > 0:
			velocity.y = 0
		velocity.y = JUMP_HEIGHT 
		jump_count = jump_count + 1
	else:
		velocity.y += GRAVITY * delta
		
	if velocity.x != 0 && is_on_floor():
		$AnimatedSprite.animation = "run"
		if velocity.x < 0:
			$AnimatedSprite.flip_h = true
		else:
			$AnimatedSprite.flip_h = false
	
	
	move_and_slide(velocity, Vector2.UP)

func get_direction():
	var direction = Vector2.ZERO
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if Input.is_action_just_pressed("ui_up"):
		direction.y = 1
	else:
		direction.y = 0
	return direction
