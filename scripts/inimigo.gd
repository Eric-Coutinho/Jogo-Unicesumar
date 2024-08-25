extends CharacterBody2D

const SPEED = 700.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = -1

@onready var sprite_2d = $Sprite2D
@onready var ray_cast_2d = $RayCast2D
@onready var animation_player = $AnimationPlayer

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if ray_cast_2d.is_colliding():
		direction *= -1
		ray_cast_2d.scale.x *= -1
	
	if direction == 1:
		sprite_2d.flip_h = false
	else:
		sprite_2d.flip_h = true
		
	velocity.x = direction * SPEED * delta

	move_and_slide()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == 'hurt':
		queue_free()
