# 玩家角色脚本
# 基础 2D 角色，支持 4 方向移动
# 继承 CharacterBody2D，由 Godot 引擎管理

class_name Player
extends CharacterBody2D

# 移动速度（像素/秒）
@export var move_speed: float = 200.0

# 格子大小（像素），用于地图对齐
const GRID_SIZE := 32.0

# 当前方向
var direction := Vector2.ZERO

func _physics_process(delta: float) -> void:
	# 处理输入
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# 如果有输入，设置速度
	if direction != Vector2.ZERO:
		velocity = direction * move_speed
		# 更新动画方向
		_update_animation_direction()
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()


func _update_animation_direction() -> void:
	# TODO: 根据 direction 切换精灵朝向
	pass


# 检查前方是否有碰撞（用于对话触发判断）
func check_front_collision() -> bool:
	var front_pos = global_position + direction * 20.0
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = front_pos
	var result = space_state.intersect_point(query)
	return result != null


# 移动到指定网格坐标（用于剧情触发）
func snap_to_grid(grid_x: int, grid_y: int) -> void:
	global_position = Vector2(grid_x * GRID_SIZE, grid_y * GRID_SIZE)
