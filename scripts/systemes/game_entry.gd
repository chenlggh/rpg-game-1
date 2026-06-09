# 游戏入口场景
# 演示：创建队伍 + 遭遇敌人 + 进入战斗

extends Node2D

@export var demo_enemy_level: int = 1

func _ready() -> void:
	# 创建主角队伍
	var heroes = []
	heroes.append(Hero.new("勇者", 1))
	heroes.append(Hero.new("法师", 1))
	heroes.append(Hero.new("骑士", 1))
	
	# 创建敌人
	var enemies = []
	enemies.append(Enemy.new("史莱姆", demo_enemy_level))
	
	# 初始化战斗管理器
	var battle_mgr = $BattleManager
	battle_mgr.initialize(heroes, enemies)
	
	# 切换到战斗场景
	var battle_scene = preload("res://scenes/battle/battle.tscn")
	var battle_instance = battle_scene.instantiate()
	get_tree().root.add_child(battle_instance)
	
	# 转移战斗管理器到战斗场景
	battle_instance.add_child(battle_mgr)
	
	# 清场
	queue_free()
