# 主角类
# 继承 Entity，增加等级、技能等 RPG 元素

class_name Hero
extends Entity

# RPG 特有属性
var level: int = 1
var exp: int = 0
var exp_to_next_level: int = 50
var skill_points: int = 0

# 技能列表
var skills: Array[Skill] = []

class Skill:
	var name: String = ""
	var mp_cost: int = 0
	var damage_multiplier: float = 1.5
	var description: String = ""

func _init(p_name: String, p_level: int = 1) -> void:
	var hp := 80 + p_level * 20
	var mp := 30 + p_level * 5
	var atk := 12 + p_level * 3
	var def := 8 + p_level * 2
	var spd := 10 + p_level * 1
	var exp_needed := 50 * p_level
	super(p_name, hp, mp, atk, def, 10 + p_level, exp_needed, 10)
	level = p_level
	exp_to_next_level = exp_needed


# 获得经验值
func gain_exp(amount: int) -> Array[String]:
	var leveled_up: Array[String] = []
	exp += amount
	
	while exp >= exp_to_next_level:
		_level_up()
		leveled_up.append("升级！等级 %d" % level)
	
	return leveled_up


# 升级
func _level_up() -> void:
	level += 1
	max_hp += 20
	current_hp = max_hp
	max_mp += 5
	current_mp = max_mp
	attack += 3
	defense += 2
	speed += 1
	exp -= exp_to_next_level
	exp_to_next_level = int(exp_to_next_level * 1.5)
	skill_points += 1


# 添加技能
func add_skill(skill: Skill) -> void:
	skills.append(skill)


# 使用技能
func use_skill(skill_index: int) -> float:
	if skill_index < skills.size():
		var skill = skills[skill_index]
		if current_mp >= skill.mp_cost:
			current_mp -= skill.mp_cost
			return skill.damage_multiplier
	return 1.0


# 重置
func reset() -> void:
	super()
	current_hp = max_hp
	current_mp = max_mp
