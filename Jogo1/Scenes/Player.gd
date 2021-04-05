extends KinematicBody2D

#Horitzontal
const velocitat = 200
var mov = Vector2(0,0)
#Vertical
var gravetat = 750
var jump_power = -350

var Attacking = false
var hp = 10000
var Moving = false
var Hit = false
var Dead = false
var Jump = false
var CanBeHit = true
var CanMove = true
var dmg_taken
onready var HealthBar = $HealthBar
onready var enemy = get_parent().get_node("Skeleton")

func update_healthbar(hp):
	HealthBar.value = hp
	
func knockback(enemy):
	
	pass
func Hit():
	hp-=dmg_taken
	$Player.play("Hit")
	print(hp)

func Death():
	$Player.play("Death")



func _physics_process(delta):
	
	mov.y += gravetat * delta
	mov.x = 0
	
	
	if Input.is_action_pressed("Right") and Attacking == false and Hit == false and CanMove == true:
		Moving = true
		mov.x = velocitat
		$Player.play("Run")
		$Player.flip_h = false
	elif Input.is_action_pressed("Left") and Attacking == false and Hit == false and CanMove == true:
		Moving = true
		mov.x = -velocitat
		$Player.play("Run")
		$Player.flip_h = true
	else:
		Moving = false
		if Attacking == false and Hit == false and Dead == false and CanMove == true:
			$Player.play("Idle")
		
	if Input.is_action_just_pressed("E") and is_on_floor() and Hit == false and CanMove == true:
		Moving = false
		if $Player.flip_h == false:
			$Player.play("Attack1")
			$AttackArea/CollisionShape2D.disabled = false
			Attacking = true

		elif $Player.flip_h == true:
			$Player.play("Attack1")
			$AttackArea2/CollisionShape2D.disabled = false
			Attacking = true
		
	if Input.is_action_just_pressed("Jump") and is_on_floor() and Attacking == false and CanMove == true:
		Jump = true
		mov.y = jump_power
	if mov.y < 0:
		$Player.play("Jump")
	if mov.y > 0 and is_on_floor() != true and Attacking == false and CanMove == true:
		$Player.play("Fall")
	
	
	if Hit == true and CanBeHit == true:
		Attacking = false
		Hit()
	
	if Dead == true:
		Hit = false
		Moving = false
		Attacking = false
		CanBeHit = false
		CanMove = false
		Death()
	
	if Moving == false:
		mov.x = 0
		
	if CanBeHit == false:
		Dead = true
	if hp <= 0: 
		Dead = true
		
	update_healthbar(hp)
	
	mov = move_and_slide(mov, Vector2.UP)
	
	
func _on_Player_animation_finished(): 
	if $Player.animation == "Attack1":
		$AttackArea/CollisionShape2D.disabled = true
		$AttackArea2/CollisionShape2D.disabled = true
		Moving = false
		Attacking = false
		Hit = false
	if $Player.animation == "Death":
		queue_free()
		get_parent().get_node("GameOver").visible = true
	if $Player.animation == "Hit":
		Hit = false
	
func _on_PHitbox_area_entered(area):
	if area.is_in_group("EnemyAttack"):
		dmg_taken = area.dmg
		if enemy.global_position.x > global_position.x:
			enemy.get_node("SkeletonSprite").flip_h = false
		if enemy.global_position.x < global_position.x:
			enemy.get_node("SkeletonSprite").flip_h = true
		if Dead == false and CanBeHit == true:
			enemy.Moving = false
			enemy.Attacking = true
			Hit = true
			
		if Dead == true:
			enemy.Moving = false
			enemy.Attacking = false
