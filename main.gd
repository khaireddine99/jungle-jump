extends Node

@export var coin : PackedScene
@export var cactus : PackedScene
@export var play_time = 10
@export var powerup_scene : PackedScene

var level = 1
var score = 0
var time_left = 5
var screensize = Vector2.ZERO
var playing = false

# Called when the node enters the scene tree for the first time.
func _ready():
	screensize = get_viewport().get_visible_rect().size
	$player.screen_size = screensize
	$player.hide()
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if playing and get_tree().get_nodes_in_group("coins").size() == 0:
		level += 1
		time_left += 5
		spawn_coins()	
		get_tree().call_group("obstacles", "queue_free")
		spaw_obstacles()
				
func new_game():
	playing = true
	level = 1
	score = 0
	time_left = play_time
	$player.start()
	$player.show()
	$GameTimer.start()
	spawn_coins()
	spaw_obstacles()
	$hud.update_score(score)
	$hud.update_time(time_left)

func spawn_coins():
	$LevelSound.play()	
	for i in level + 4:
		var c = coin.instantiate()
		add_child(c)
		c.screensize = screensize	
		c.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))
	$PowerUpTimer.wait_time = 3
	$PowerUpTimer.start()

func spaw_obstacles():
	for i in level + 1:
		var new_cactus = cactus.instantiate()
		add_child(new_cactus)
		new_cactus.screensize = screensize
		new_cactus.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))

func _on_game_timer_timeout():
	time_left -= 1
	$hud.update_time(time_left)
	if time_left <= 0:
		game_over()
	
func _on_player_hurt():
	game_over()

func _on_player_pickup(type):
	match type:
		"coin":
			$CoinSound.play()
			score += 1
			$hud.update_score(score)
		"powerup":
			$PowerUpSound.play()
			time_left += 5	
			$hud.update_time(time_left)
		
func game_over():
	playing = false
	$GameTimer.stop()
	get_tree().call_group("coins", "queue_free")
	get_tree().call_group("obstacles", "queue_free")
	$hud.show_game_over()
	$player.die()
	$EndSound.play()
	
func _on_hud_start_game():
	new_game()
	
func _on_power_up_timer_timeout():
	var p = powerup_scene.instantiate()
	add_child(p)
	p.screensize = screensize
	p.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))
	
	
	
	
	
	
	
