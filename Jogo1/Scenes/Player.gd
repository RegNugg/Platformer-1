extends KinematicBody2D

#Horitzontal
const velocitat = 200
var mov = Vector2(0,0)
#Vertical
var gravetat = 750
var jump_power = -350
var Attacking = false


func _physics_process(delta):
	
	mov.y += gravetat * delta
	mov.x = 0
	
	#Moviment esquerra-dreta
	
		
	if Input.is_action_pressed("Right") and Attacking == false:
		mov.x = velocitat
		$Player.play("Run")
		$Player.flip_h = false
	elif Input.is_action_pressed("Left") and Attacking == false:
		mov.x = -velocitat
		$Player.play("Run")
		$Player.flip_h = true
	else:
		mov.x = 0 
		if Attacking == false:
			$Player.play("Idle")
		
	if Input.is_action_just_pressed("E") and is_on_floor():
		if $Player.flip_h == false:
			$Player.play("Attack1")
			$AttackArea/CollisionShape2D.disabled = false
			Attacking = true

		elif $Player.flip_h == true:
			$Player.play("Attack1")
			$AttackArea2/CollisionShape2D.disabled = false
			Attacking = true
	
	#Moviment salt-caiguda
		
	if Input.is_action_just_pressed("Jump") and is_on_floor() and Attacking == false:
		mov.y = jump_power
	if mov.y < 0:
		$Player.play("Jump")
	if mov.y > 0 and is_on_floor() != true and Attacking == false:
		$Player.play("Fall")
	
	mov = move_and_slide(mov, Vector2.UP)
	


func _on_Player_animation_finished(): 
	if $Player.animation == "Attack1":
		$AttackArea/CollisionShape2D.disabled = true
		$AttackArea2/CollisionShape2D.disabled = true
		Attacking = false
