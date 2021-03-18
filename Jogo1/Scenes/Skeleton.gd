extends KinematicBody2D



func _physics_process(delta):
	$Skeleton.flip_h = true
	$Skeleton.play("Idle")
	
	


func _on_Area2D2_area_entered(area):
	$Skeleton.play("React")
	$Skeleton.play("Idle")
	print("Enemic xD")
