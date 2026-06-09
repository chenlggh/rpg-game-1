# 世界管理器
# 管理地图场景、玩家移动、NPC 交互、遇敌

class_name WorldManager
extends Node2D

@onready var player: CharacterBody2D = $Player

# 遇敌概率（每步）
const ENCOUNTER_CHANCE = 0.08

# 当前对话对话框
var active_dialogue: DialogueBox = null

# 上次移动时间（用于随机遇敌冷却）
var last_move_time: float = 0.0

func _physics_process(delta: float) -> void:
	# 检查前方是否有 NPC
	if Input.is_action_just_pressed("interact"):
		var nearby = check_nearby_npc()
		if nearby:
			start_npc_dialogue(nearby)
	
	# 随机遇敌（移动时触发）
	var moved = player.velocity.length() > 0
	if moved and Time.get_ticks_msec() - last_move_time > 500:
		last_move_time = Time.get_ticks_msec()
		if randf() < ENCOUNTER_CHANCE:
			trigger_encounter()


# 检查附近是否有 NPC
func check_nearby_npc() -> Area2D:
	for child in get_children():
		if child is Area2D and child.has_node("NPC_Sprite"):
			var dist = player.global_position.distance_to(child.global_position)
			if dist < 50.0:
				return child
	return null


# 启动 NPC 对话
func start_npc_dialogue(npc: Area2D) -> void:
	# TODO: 加载对话数据
	var dialogue = DialogueData.new()
	dialogue.add_line("村长", "欢迎来到这个宁静的村庄！")
	dialogue.add_line("村长", "前方森林里有怪物出没，要小心！")
	dialogue.add_option(0, "没问题！", 1)
	
	var dialogue_box = preload("res://scripts/systemes/dialogue_box.tscn").instantiate()
	add_child(dialogue_box)
	dialogue_box.start_dialogue(dialogue)


# 触发遇敌
func trigger_encounter() -> void:
	var battle_scene = preload("res://scenes/battle/battle.tscn")
	var battle_instance = battle_scene.instantiate()
	get_tree().root.add_child(battle_instance)
	
	# 创建随机敌人
	var enemies = []
	var enemy_types = [
		{"name": "史莱姆", "level": 1},
		{"name": "哥布林", "level": 2},
		{"name": "狼", "level": 1},
	]
	var type = enemy_types[randi() % enemy_types.size()]
	enemies.append(Enemy.new(type["name"], type["level"]))
	
	# 获取队伍
	var heroes = _get_hero_party()
	
	# 初始化战斗
	var battle_mgr = battle_instance.get_node_or_null("BattleManager")
	if battle_mgr:
		battle_mgr.initialize(heroes, enemies)


# 获取玩家队伍（从场景树中查找）
func _get_hero_party() -> Array[Hero]:
	var party = []
	# 从全局变量或单例中获取
	if Engine.has_singleton("GameRegistry"):
		party = GameRegistry.get_party()
	return party
