extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (PackedScene) var Mob
var score

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$GameOver.play()
	
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$Music.play()

func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
	
func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_MobTimer_timeout():
	# Pick a random location on MobPath
	$MobPath/MobSpawnLocation.set_offset(randi())
	# Instance a new mob
	var mob = Mob.instance()
	# Push it as a node
	add_child(mob)
	# Set the direction as perpendicular to the spawn line
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	# Set the mob position to a random position
	mob.position = $MobPath/MobSpawnLocation.position
	# Randomize direction
	direction  += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	# Set movement velocity
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)
	$HUD.connect("start_game", mob, "_on_start_game")
