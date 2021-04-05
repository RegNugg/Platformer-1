extends KinematicBody2D



var dead = false
var hp = 100
var Hit = false
var gravetat = 750
var Attacking = false
var Moving = true
var mov = Vector2(0,0)
const velocitat = 100
onready var player = get_parent().get_node("Player")
var objectiu
var dmg_taken
var CanAttack = true

func Death():
	Moving = false
	$AttackArea/CollisionShape2D.disabled = true
	$AttackArea2/CollisionShape2D.disabled = true
	$SkeletonSprite.play("Dead")
	
func Hit():
	Moving = false
	$SkeletonSprite.play("Hit")
	hp -= dmg_taken
	
func Attack():
	Moving = false
	$SkeletonSprite.play("Attack")
		
	
func _physics_process(delta):
	mov.y += gravetat * delta
	
	if $SkeletonSprite.flip_h == false and Moving == true:
		mov.x = -velocitat
	if $SkeletonSprite.flip_h == true and Moving == true:
		mov.x = velocitat
	
	if dead == false and Hit == false and Attacking == false and Moving == false:
		$SkeletonSprite.play("Idle")
		
	if Moving == false:
		mov.x = 0
	if Moving == true:
		$SkeletonSprite.play("Moving")
	if Attacking == true and Hit == false and CanAttack == true:
		Attack()
	if Hit == true:
		Attacking = false
		Moving = false
		Hit()
	if dead == true:
		Death()
		Hit = false
		Moving = false
		Attacking = false
	if player.hp <= 0:
		CanAttack = false
		player.get_node("Player").play("Death")
	
	

	mov = move_and_slide(mov, Vector2.UP)
	
	
func _on_Hitbox_area_entered(area):
	if area.is_in_group("Sword"):
		dmg_taken = area.dmg
		if hp > 0:
			Hit = true
			
		if hp <= 0:
			dead = true
	
func _on_Skeleton_animation_finished():
	if $SkeletonSprite.animation == "Dead":
		queue_free()
	if $SkeletonSprite.animation == "Hit":
		Hit = false
		Moving = false
	if $SkeletonSprite.animation == "Attack":
		Moving = false
		Attacking = false

func _on_Hitbox_body_entered(body):
	if body.is_in_group("ForeGround"):
		if $SkeletonSprite.flip_h == true:
			$SkeletonSprite.flip_h = false
			
		if $SkeletonSprite.flip_h == false:
			$SkeletonSprite.flip_h = true
		
		
		mov.x = mov.x * -1

func _on_AttackArea_body_entered(body):
	if body.has_method("_physics_process") and CanAttack == true:
		Moving = false
		objectiu = body
		Attacking = true
		$SkeletonSprite.flip_h = false
		print ("Detected")

func _on_AttackArea2_body_entered(body):
	if body.has_method("_physics_process(delta)") and CanAttack == true:
		Moving = false
		objectiu = body
		Attacking = true
		$SkeletonSprite.flip_h = true
		print ("Detected")


func _on_AttackArea_body_exited(body):
	if body.has_method("_physics_process(delta)"):
		Attacking = false
		Moving = false
		Hit = false

func _on_AttackArea2_body_exited(body):
	if body.has_method("_physics_process(delta)"):
		Attacking = false
		Moving = false
		Hit = false
