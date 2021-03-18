extends KinematicBody2D

#Horitzontal
const velocitat = 200
var mov = Vector2(0,0)
#Vertical
var gravetat = 750
var jump_power = -350

func _physics_process(delta):
	
	mov.y += gravetat * delta
	mov.x = 0
	
	#Moviment esquerra-dreta
	
		
	if Input.is_action_pressed("Right"):
		mov.x = velocitat
		$Player.play("Run")
		$Player.flip_h = false
	elif Input.is_action_pressed("Left"):
		mov.x = -velocitat
		$Player.play("Run")
		$Player.flip_h = true
	else:
		$Player.play("Idle")
	
	#Moviment salt-caiguda
		
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		mov.y = jump_power
	if mov.y < 0:
		$Player.play("Jump")
	if mov.y > 0 and is_on_floor() != true:
		$Player.play("Fall")
	
	#Atac
	if Input.is_action_pressed("E") and is_on_floor():
		$Player.play("Attack1")
		
	mov = move_and_slide(mov, Vector2.UP)
	mov.x = lerp(mov.x, 0, 0.2)
