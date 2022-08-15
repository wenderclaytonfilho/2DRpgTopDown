extends KinematicBody2D

onready var animation:AnimationPlayer = get_node("Animation")
onready var sprite:Sprite = get_node('Sprite')

var playerRef = null
var velocity:Vector2
var can_die:bool = false

export (int) var speed


func _physics_process(_delta:float)->void:
	move()
	animate()
	verifyDirection()
	

func move()->void:
	if playerRef!=null:
		var distance:Vector2 = playerRef.global_position - global_position
		var direction :Vector2 = distance.normalized()
		var distanceLength:float = distance.length()
		if distanceLength<=8:
			playerRef.kill()
			velocity=Vector2.ZERO
		else:
			velocity = speed*direction
	
	else:
		velocity=Vector2.ZERO
		
	velocity = move_and_slide(velocity)

func animate():
	if can_die:
		animation.play('death')
		set_physics_process(false)
	elif velocity!=Vector2.ZERO:
		animation.play('walking')
	else:
		animation.play('idle')

func verifyDirection()->void:
	if velocity.x>0:
		sprite.flip_h=false
	elif velocity.x<0:
		sprite.flip_h=true

func _on_body_entered(body):
	if body.is_in_group('player'):
		playerRef=body


func _on_body_exited(body):
	if body.is_in_group('player'):
		playerRef=null

#Kill Function
func _on_area_entered(area):
	if area.is_in_group('player_attack'):
		can_die=true;


func _on_animation_finished(anim_name):
	if anim_name =='death':
		queue_free()
		
