extends CharacterBody2D

signal health_changed

var run_speed = 75
var attacking = false
var health = 5
var direction = "right"

func _physics_process(delta):
	var input = Input.get_vector("left", "right", "up", "down")
	velocity = input * run_speed
	if attacking:
		velocity = Vector2.ZERO
		return
	move_and_slide()

	if velocity == Vector2.ZERO:
		$AnimationPlayer.play("idle %s" % direction)
		
	if velocity.x != 0:
		transform.x.x = sign(velocity.x)
		direction = "sideways"
		$AnimationPlayer.play("walk sideways")
	
	if velocity.y < 0:
		$AnimationPlayer.play("walk back")
		direction = "back"
	
	if velocity.y > 0:
		$AnimationPlayer.play("walk forward")
		direction = "forward"

func _input(event):
	if event.is_action_pressed("attack"):
		attack()
		
func attack():
	$AnimationPlayer.play("attack forward")
	attacking = true
	await $AnimationPlayer.animation_finished
	attacking = false

func _on_hurtbox_body_entered(body):
	body.hurt(1)

func hurt(amount):
	health -= amount
	health_changed.emit(health)
	if health <= 0:
		$AnimationPlayer.play("hurt")
