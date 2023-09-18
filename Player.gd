extends Area2D
signal hit

@export var speed = 200 # define the speed
@export var health = 5	# define the hp
var screen_size
var target = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	#if position.distance_to(target) > 10:
	#	velocity = target - position
	
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedPlayer.play()
	else:
		$AnimatedPlayer.animation = "stand"
		$AnimatedPlayer.play()
	
	position += velocity * delta
	#position = position.clamp(Vector2.ZERO, screen_size)
	position.x = clamp(position.x, 27, screen_size.x - 27)
	position.y = clamp(position.y, 32, screen_size.y - 32)
	if velocity.x != 0:
		$AnimatedPlayer.animation = "walk"
		$AnimatedPlayer.flip_v = false
		# See the note below about boolean assignment.
		$AnimatedPlayer.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedPlayer.animation = "walk"
		#$AnimatedPlayer.flip_v = velocity.y > 0

func _on_body_entered(body):
	hide()
	hit.emit()
	$CollisionPlayer.set_deferred("disabled", true)
	
func start(pos):
	position = pos
	target = pos
	show()
	$CollisionPlayer.disabled = false


#func _input(event):
#	if event is InputEventScreenTouch and event.pressed:
#		target = event.position
