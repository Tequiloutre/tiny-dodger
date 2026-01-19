extends Node

@export var arrow_scene: PackedScene
@export var arrow_min_speed: float
@export var arrow_max_speed: float
var score

func _ready() -> void:
	pass

func game_over() -> void:
	$ScoreTimer.stop()
	$ArrowTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()

func new_game():
	score = 0
	get_tree().call_group("arrows", "queue_free")
	$Warrior.spawn($SpawnPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Prepare yourself...")
	$Music.play()

func _on_arrow_timer_timeout() -> void:
	var arrow = arrow_scene.instantiate()
	
	var arrow_spawn_location = $ArrowPath/ArrowSpawnLocation
	arrow_spawn_location.progress_ratio = randf()
	
	arrow.position = arrow_spawn_location.position
	
	var direction = arrow_spawn_location.rotation + PI / 2
	
	direction += randf_range(-PI / 4, PI / 4)
	arrow.rotation = direction
	
	var velocity = Vector2(randf_range(arrow_min_speed, arrow_max_speed), 0.0)
	arrow.linear_velocity = velocity.rotated(direction)
	
	$ArrowSound.position = arrow.position
	$ArrowSound.play()
	
	add_child(arrow)

func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout() -> void:
	$ArrowTimer.start()
	$ScoreTimer.start()
