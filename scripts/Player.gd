extends CharacterBody2D
const SPEED = 300.0

const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var camera_2d = $Camera2D

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("cima") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	direction = Input.get_axis("esquerda", "direita")
	if direction:
		velocity.x = direction * SPEED
		animated_sprite_2d.scale.x = direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	_set_state()
	move_and_slide()
	
func _set_state():
	var state = 'idle'
	
	if !is_on_floor():
		state = 'jump'
	elif direction != 0:
		state = 'run'
		
	if animated_sprite_2d.name != state:
		animated_sprite_2d.play(state)

func _on_hurtbox_body_entered(body):
	if body.is_in_group('inimigos'):
		camera_2d.reparent(get_parent())
		queue_free()
