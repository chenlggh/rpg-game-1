# 实体基类
# 所有角色和敌人都继承此类

class_name Entity
extends RefCounted

# 基础属性
var name: String = ""
var max_hp: int = 100
var current_hp: int = 100
var max_mp: int = 50
var current_mp: int = 50
var attack: int = 15
var defense: int = 10
var speed: int = 10
var exp_reward: int = 10
var gold_reward: int = 5

# 信号
signal hp_changed(new_hp: int)
signal died

func _init(p_name: String, p_max_hp: int, p_max_mp: int, p_attack: int, p_defense: int, p_speed: int, p_exp: int = 10, p_gold: int = 5) -> void:
	name = p_name
	max_hp = p_max_hp
	current_hp = max_hp
	max_mp = p_max_mp
	current_mp = max_mp
	attack = p_attack
	defense = p_defense
	speed = p_speed
	exp_reward = p_exp
	gold_reward = p_gold


# 受到伤害
func take_damage(amount: int) -> int:
	var damage = max(1, amount - defense)
	current_hp = max(0, current_hp - damage)
	hp_changed.emit(current_hp)
	if current_hp <= 0:
		died.emit()
	return damage


# 恢复 HP
func heal(amount: int) -> int:
	var old_hp = current_hp
	current_hp = min(max_hp, current_hp + amount)
	return current_hp - old_hp


# 恢复 MP
func restore_mp(amount: int) -> int:
	var old_mp = current_mp
	current_mp = min(max_mp, current_mp + amount)
	return current_mp - old_mp


# 是否存活
func is_alive() -> bool:
	return current_hp > 0


# 重置状态
func reset() -> void:
	current_hp = max_hp
	current_mp = max_mp
