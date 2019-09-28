extends Area2D

signal hit

export var speed = 400
var screen_size

func _ready():
	screen_size = get_viewport_rect().size
	hide()
	
func _process(delta):
	var velocity = _check_inputs().normalized() * speed
	_set_animation(velocity)
	_set_position(velocity,delta)

func _set_animation(var velocity):
	if velocity.length() > 0:
		$AnimatedSprite.play()
		_flip_sprite(velocity)
	else:
		$AnimatedSprite.stop()

func _flip_sprite(var velocity):
	if velocity.x != 0:
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0

func _check_inputs():
	var dir = Vector2()
	if Input.is_action_pressed("ui_right"):
		dir.x += 1
	if Input.is_action_pressed("ui_left"):
		dir.x -= 1
	if Input.is_action_pressed("ui_down"):
		dir.y += 1
	if Input.is_action_pressed("ui_up"):
		dir.y -= 1
	return dir

func _set_position(var velocity, var delta):
	position += velocity * delta
	_clamp_position(position)

func _clamp_position(var position):
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)


func _on_Player_body_entered(body):
	hide()
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled",true)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

