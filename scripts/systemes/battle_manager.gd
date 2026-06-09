# 战斗管理器
# 控制回合制战斗的流程：玩家回合 → 敌人回合 → 判定胜负

class_name BattleManager
extends Node

signal turn_changed(phase: String)
signal enemy_defeated(enemy_name: String)
signal battle_ended(result: String)

# 玩家队伍
var party: Array[Hero] = []
# 敌人列表
var enemies: Array[Enemy] = []
# 当前回合方
var current_phase: String = "player"
# 当前行动的角色索引
var action_index: int = 0
# 战斗日志
var battle_log: Array[String] = []

func initialize(player_party: Array[Hero], enemy_list: Array[Enemy]) -> void:
	party = player_party
	enemies = enemy_list
	battle_log.clear()
	current_phase = "player"
	action_index = 0
	# 过滤存活敌人
	enemies = enemies.filter(func(e): return e.is_alive())
	turn_changed.emit("player")


# 执行玩家行动
func player_action(action: String, target_index: int = -1) -> void:
	if current_phase != "player":
		return
	
	var hero = party[action_index]
	if not hero.is_alive():
		_next_hero()
		return
	
	match action:
		"attack":
			_execute_attack(hero, target_index)
		"flee":
			_execute_flee(hero)
		"_":
			battle_log.append("未知行动")
	
	# 检查敌人是否全部死亡
	if enemies.is_empty() or not enemies.any(func(e): return e.is_alive()):
		battle_ended.emit("victory")
		return
	
	# 切换到敌人回合
	current_phase = "enemy"
	turn_changed.emit("enemy")
	# 延迟后执行敌人行动
	await get_tree().create_timer(0.5).timeout
	_execute_enemy_turn()


# 执行攻击
func _execute_attack(attacker: Entity, target_index: int) -> void:
	var target: Entity
	if target_index >= 0:
		if attacker is Hero:
			target = enemies[target_index] if target_index < enemies.size() else null
		else:
			target = party[target_index] if target_index < party.size() else null
	
	if target == null:
		# 随机选一个目标
		if attacker is Hero:
			var alive_enemies = enemies.filter(func(e): return e.is_alive())
			if alive_enemies.size() > 0:
				target = alive_enemies[randi() % alive_enemies.size()]
		else:
			var alive_heroes = party.filter(func(h): return h.is_alive())
			if alive_heroes.size() > 0:
				target = alive_heroes[randi() % alive_heroes.size()]
	
	if target == null:
		battle_log.append("目标不存在")
		_next_hero()
		return
	
	var damage = target.take_damage(attack)
	var attacker_name = attacker.name
	var target_name = target.name
	battle_log.append("%s 对 %s 造成了 %d 点伤害" % [attacker_name, target_name, damage])
	
	if not target.is_alive():
		battle_log.append("%s 被击败了！" % target_name)
		if attacker is Hero:
			enemy_defeated.emit(target_name)


# 执行逃跑
func _execute_flee(hero: Hero) -> void:
	var success = randi() % 100 < hero.speed * 3
	if success:
		battle_log.append("逃跑成功！")
		battle_ended.emit("fled")
	else:
		battle_log.append("逃跑失败！")
		current_phase = "enemy"
		turn_changed.emit("enemy")
		await get_tree().create_timer(0.5).timeout
		_execute_enemy_turn()


# 执行敌人回合
func _execute_enemy_turn() -> void:
	for enemy in enemies:
		if not enemy.is_alive():
			continue
		
		var action = enemy.get_action(party)
		if action.action == "attack":
			var target = action.target
			if target and target.is_alive():
				var damage = target.take_damage(enemy.attack)
				battle_log.append("%s 对 %s 造成了 %d 点伤害" % [enemy.name, target.name, damage])
				
				if not target.is_alive():
					battle_log.append("%s 被击败了！" % target.name)
		
		# 检查玩家是否全部死亡
		if not party.any(func(h): return h.is_alive()):
			battle_ended.emit("defeat")
			return
	
	# 敌人回合结束，回到玩家回合
	current_phase = "player"
	action_index = 0
	turn_changed.emit("player")


# 切换到下一个可操作的英雄
func _next_hero() -> void:
	action_index += 1
	while action_index < party.size() and not party[action_index].is_alive():
		action_index += 1
	
	if action_index >= party.size():
		# 所有英雄都行动过了
		current_phase = "enemy"
		turn_changed.emit("enemy")
		await get_tree().create_timer(0.5).timeout
		_execute_enemy_turn()
