# 世界管理器
# 管理地图场景、玩家移动、NPC 交互

class_name WorldManager
extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var tile_map: TileMap = $TileMap

# NPC 列表
var npcs: Array[Area2D] = []

# 当前对话框（单例）
var active_dialogue: DialogueBox = null

func _ready() -> void:
	# 收集所有 NPC
	for child in get_children():
		if child is Area2D and child.has_node("NPC_Sprite"):
			npcs.append(child as Area2D)
			_setup_npc_interaction(child as Area2D)

func _setup_npc_interaction(npc: Area2D) -> void:
	var collision = npc.get_node("NPC_Collision")
	if collision:
		collision.shape.collision_layer = 1
		collision.shape.collision_mask = 1

# 检查玩家是否在 NPC 附近并可交互
func check_nearby_npc() -> Area2D:
	var player_pos = player.global_position
	for npc in npcs:
		var dist = player_pos.distance_to(npc.global_position)
		if dist < 40.0:
			return npc
	return null

# 启动 NPC 对话
func start_npc_dialogue(npc: Area2D, dialogue_data: DialogueData) -> void:
	var dialogue_box = preload("res://scripts/systemes/dialogue_box.tscn").instantiate()
	add_child(dialogue_box)
	dialogue_box.start_dialogue(dialogue_data)
	dialogue_box.dialogue_finished.connect(_on_dialogue_finished)

func _on_dialogue_finished() -> void:
	pass

# 切换地图场景
func switch_to_scene(scene_path: String) -> void:
	get_tree().change_scene_to_file(scene_path)
