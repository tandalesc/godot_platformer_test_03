extends KinematicBody2D

export (float) var run_speed = 150
export (float) var jump_speed = -300
export (float) var push = 30

var GRAVITY = 500
var velocity = Vector2()

var double_jump_allowed = false

func process_input(delta):
	velocity.x = 0
	if Input.is_action_pressed('ui_right'):
		$AnimatedSprite.flip_h = false
		velocity.x += run_speed
	if Input.is_action_pressed('ui_left'):
		$AnimatedSprite.flip_h = true
		velocity.x -= run_speed
	if Input.is_action_pressed('ui_accept') and is_on_floor():
		$AnimatedSprite.play('jump_start')
		velocity.y = jump_speed

func process_animation(delta):		
	if $AnimatedSprite.animation == 'idle' and abs(velocity.x) > 0.5:
		$AnimatedSprite.play('walk')
	if $AnimatedSprite.animation == 'walk' and abs(velocity.x) > 2:
		$AnimatedSprite.play('run')
	if $AnimatedSprite.animation == 'run' and abs(velocity.x) < 0.1:
		$AnimatedSprite.play('idle')
	if $AnimatedSprite.animation == 'jump_start' and abs(velocity.y) < 1.0:
		$AnimatedSprite.play('jump_peak')
	if $AnimatedSprite.animation == 'jump_peak' and is_on_floor():
		$AnimatedSprite.play('jump_land')

func animation_finished():
	if $AnimatedSprite.animation == 'jump_land':
		$AnimatedSprite.play('idle')

func _physics_process(delta):
	velocity.y += GRAVITY * delta
	process_input(delta);
	velocity = move_and_slide(velocity, Vector2.UP, false, 4, PI/4, false)
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group('bodies'):
			collision.collider.apply_central_impulse(-collision.normal * push)

func _process(delta):
	#update animation state
	process_animation(delta)
	
func _ready():
	#for hooks that only trigger when an animation ends
	$AnimatedSprite.connect('animation_finished', self, 'animation_finished')
	pass