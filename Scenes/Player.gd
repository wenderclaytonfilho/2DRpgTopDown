extends KinematicBody2D

var velocity:Vector2
var can_die:bool = false
var can_attack:bool = false

const PARTICLES:PackedScene =preload('res://Scenes/Player/RunParticles.tscn')

onready var animation:AnimationPlayer = get_node('Animation')
onready var sprite:Sprite = get_node("Sprite")
onready var collision:CollisionShape2D = get_node("AttackArea/Collision")


export(int) var  speed

#Main
func _physics_process(delta:float)->void:
	move()
	attack()
	verifyDirection()
	animate()

func move() -> void:
	var direction_vector :Vector2=Vector2(
		Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left"),
		Input.get_action_strength('ui_down')-Input.get_action_strength('ui_up')
	).normalized()
	
	velocity = direction_vector*speed
	velocity=move_and_slide(velocity)
	
func attack()->void:
	if Input.is_action_just_pressed("ui_select") and not can_attack:
		can_attack=true

	
func animate()->void:
	if can_die:
		animation.play("dead")
		set_physics_process(false)
	elif can_attack:
		animation.play('attack')
		set_physics_process(false)
	elif velocity != Vector2.ZERO:
		animation.play('run')
	else:
		animation.play('Idle')
	
func verifyDirection() -> void:
	if velocity.x >0:
		sprite.flip_h=false
		collision.position = Vector2(20,8)
	elif velocity.x<0:
		sprite.flip_h=true
		collision.position = Vector2(-20,8)
		
func instanceParticles()->void:
	var particle = PARTICLES.instance()
	#Adding particles to scene
	get_tree().root.call_deferred('add_child',particle)
	particle.global_position=global_position+Vector2(0,16)
	particle.playParticles()

func kill() -> void:
	can_die=true


func _on_animation_finished(anim_name):
	#It restart the game if you die!
	if anim_name == 'dead':
		var reload:bool = get_tree().reload_current_scene()
	elif anim_name=='attack':
		can_attack=false
		set_physics_process(true)
		
