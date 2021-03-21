extends KinematicBody2D

var dead = false
var hits = 0
var Hit = false
var gravetat = 750
var Attacking = false
var mov = Vector2(0,0)
const velocitat = 150


func _physics_process(delta):
	mov.y += gravetat * delta
	mov.x = 0
	
	if dead == false and Hit == false and Attacking == false:
		$Skeleton.play("Idle")
	
	mov = move_and_slide(mov, Vector2.UP)
	
func _on_Hitbox_area_entered(area):
	if area.is_in_group("Sword"):
		if hits != 2:
			Hit = true
			hits+= 1
			$Skeleton.play("Hit")
		if hits == 2:
			dead = true
			hits = 0
			$Skeleton.play("Dead")


func _on_Skeleton_animation_finished():
	if $Skeleton.animation == "Dead":
		queue_free()
