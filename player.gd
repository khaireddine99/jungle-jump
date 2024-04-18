extends Area2D

signal pickup
signal hurt

@export var speed = 350
var Velocity = Vector2.ZERO
var screen_size = Vector2(480, 720)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	position += Velocity * speed * delta
	
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	if Velocity.length() > 0:
		$AnimatedSprite2D.animation = "run"
	else:
		$AnimatedSprite2D.animation = "idle"
	if Velocity.x != 0:
		$AnimatedSprite2D.flip_h = Velocity.x < 0 	
		
func start():
	set_process(true)
	position = screen_size / 2
	$AnimatedSprite2D.animation = "idle"
	
func die():
	$AnimatedSprite2D.animation = "hurt"
	set_process(false)

func _on_area_entered(area):
	if area.is_in_group("coins"):
		area.pickup()
		pickup.emit("coin")
	
	if area.is_in_group("powerups"):
		area.pickup()
		pickup.emit("powerup")	
		
	if area.is_in_group("obstacles"):
		hurt.emit()
		die()
