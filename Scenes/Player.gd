extends KinematicBody2D

var velocity:Vector2

onready var animation:AnimationPlayer = get_node('Animation')
onready var sprite:Sprite = get_node("Sprite")
export(int) var  speed

#Main
func _physics_process(delta:float)->void:
	move()
	verifyDirection()
	animate()

func move() -> void:
	var direction_vector :Vector2=Vector2(
		Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left"),
		Input.get_action_strength('ui_down')-Input.get_action_strength('ui_up')
	).normalized()
	
	velocity = direction_vector*speed
	velocity=move_and_slide(velocity)
	
	
func animate()->void:
	if velocity != Vector2.ZERO:
		animation.play('run')
	else:
		animation.play('Idle')
	
func verifyDirection() -> void:
	if velocity.x >0:
		sprite.flip_h=false
	elif velocity.x<0:
		sprite.flip_h=true

