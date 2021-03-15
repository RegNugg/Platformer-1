extends KinematicBody2D
const velocitat = 500
var mov = Vector2()
var gravetat = 90
func _physics_process(delta):
	mov.y += gravetat * delta
	mov.x = 0
	if Input.is_action_pressed("Left"):
		mov.x = -velocitat
	if Input.is_action_pressed("Right"):
		mov.x = velocitat
	mov = mov.normalized() * velocitat
	move_and_slide(mov)
