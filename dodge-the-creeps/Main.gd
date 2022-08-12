extends Node

export(PackedScene) var mob_scene
var score

func _ready():
	randomize() #important to allow the scene to get a random number each time for mobs

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	
	# Stop music on game over and play death sound
	$Bgm.stop()
	$DeathSound.play()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")
	
	# For Music
	$Bgm.play()

func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()


func _on_MobTimer_timeout():
	#Create new instance of Mob scene // this is how it will be added later as child
	var mob = mob_scene.instance()
	
	# Choose random location on Path2d
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.offset = randi()
	
	# Set mob's direction perpendicular to path direction
	var direction = mob_spawn_location.rotation + PI / 2
	
	# Set mob's position to a random location
	mob.position = mob_spawn_location.position
	
	# add direction randomness
	direction += rand_range(-PI / 4, PI /4)
	mob.rotation = direction
	
	# Choose velocity for mob
	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	# Spawn mob by adding to the scene as a child
	add_child(mob)
