# 敌人类

class_name Enemy
extends Entity

# 简单 AI 行为类型
enum Behavior {
	RANDOM,      # 随机攻击
	BULK_UP,     # 低血量时强化
	FLEE         # 低血量时逃跑
}

var behavior: Behavior = Behavior.RANDOM

func _init(p_name: String, p_level: int) -> void:
	var hp := 40 + p_level * 15
	var mp := 10 + p_level * 3
	var atk := 8 + p_level * 3
	var def := 5 + p_level * 2
	var spd := 5 + p_level * 2
	var exp := 15 + p_level * 5
	var gold := 5 + p_level * 3
	super(p_name, hp, mp, atk, def, spd, exp, gold)
	
	# 根据等级决定行为
	if p_level >= 3:
		behavior = Behavior.BULK_UP


# 获取敌人行动（简单 AI）
func get_action(player_party: Array[Hero]) -> Dictionary:
	match behavior:
		Behavior.RANDOM:
			return {action = "attack", target = player_party[randi() % player_party.size()]}
		Behavior.BULK_UP:
			if current_hp < max_hp * 0.3:
				return {action = "attack", target = player_party[randi() % player_party.size()]}
			else:
				return {action = "attack", target = player_party[randi() % player_party.size()]}
		Behavior.FLEE:
			if current_hp < max_hp * 0.2:
				return {action = "flee", target = null}
			else:
				return {action = "attack", target = player_party[randi() % player_party.size()]}
	return {action = "attack", target = player_party[0]}
