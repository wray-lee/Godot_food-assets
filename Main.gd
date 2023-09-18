extends Node

#@export var follow: PackedScene 
@export var mob_scene : PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func new_game():
	get_tree().call_group("mobs", "queue_free")
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$Music.play()
	$HUD.show_message("Get Ready")


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathMusic.play()


func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()


func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()
	# mob出生点
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")	# 获取mob出生点
	mob_spawn_location.progress_ratio = randf()						# mob出生点为随机位置
	mob.position = mob_spawn_location.position						# 应用mob出生点
	# mob移动方向
	var direction = mob_spawn_location.rotation + PI / 2			# mob方向与出生方向垂直
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	# 定义mob速度
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	# 生成mob
	add_child(mob)


func _on_hud_start_game():
	pass # Replace with function body.
