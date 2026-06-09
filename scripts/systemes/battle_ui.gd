# 战斗 UI 场景
# 显示战斗信息、角色状态、行动菜单

extends Node2D

@onready var battle_manager: BattleManager = $BattleManager
@onready var party_hp_bar_0: TextureProgressBar = $UI/PartyHPBar0
@onready var party_hp_bar_1: TextureProgressBar = $UI/PartyHPBar1
@onready var party_hp_bar_2: TextureProgressBar = $UI/PartyHPHPBar2
@onready var enemy_hp_bar: TextureProgressBar = $UI/EnemyHPBar
@onready var log_label: Label = $UI/LogLabel
@onready var action_menu: VBoxContainer = $UI/ActionMenu
@onready var action_labels: Array[Label] = [$UI/ActionMenu/AttackLabel, $UI/ActionMenu/FleeLabel]
@onready var status_label: Label = $UI/StatusLabel

var current_hero_index: int = 0
var selected_action: String = "attack"

func _ready() -> void:
	$BattleManager.battle_ended.connect(_on_battle_ended)
	$BattleManager.turn_changed.connect(_on_turn_changed)
	
	# 默认选中攻击
	selected_action = "attack"
	_update_action_menu()
	_update_ui()


func _unhandled_input(event: InputEvent) -> void:
	if not $BattleManager.is_node_ready() or $BattleManager.current_phase != "player":
		return
	
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_UP:
			current_hero_index = max(0, current_hero_index - 1)
			_update_action_menu()
		elif event.keycode == KEY_DOWN:
			current_hero_index = min($BattleManager.party.size() - 1, current_hero_index + 1)
			_update_action_menu()
		elif event.keycode == KEY_LEFT:
			selected_action = "flee" if selected_action == "attack" else "attack"
			_update_action_menu()
		elif event.keycode == KEY_RIGHT or event.keycode == KEY_ENTER or event.keycode == KEY_SPACE:
			_execute_action()


func _execute_action() -> void:
	var hero = $BattleManager.party[current_hero_index]
	if not hero.is_alive():
		return
	
	if selected_action == "attack":
		# 攻击第一个存活的敌人
		for i in range($BattleManager.enemies.size()):
			if $BattleManager.enemies[i].is_alive():
				$BattleManager.player_action("attack", i)
				break
	elif selected_action == "flee":
		$BattleManager.player_action("flee")


func _update_action_menu() -> void:
	if current_hero_index < $BattleManager.party.size():
		var hero = $BattleManager.party[current_hero_index]
		status_label.text = "【%s Lv.%d】 HP:%d/%d MP:%d/%d" % [hero.name, hero.level, hero.current_hp, hero.max_hp, hero.current_mp, hero.max_mp]
		action_labels[0].text = "攻击 (←→切换)"
		action_labels[1].text = "逃跑"
		if selected_action == "attack":
			action_labels[0].modulate = Color.YELLOW
		else:
			action_labels[0].modulate = Color.WHITE
		if selected_action == "flee":
			action_labels[1].modulate = Color.YELLOW
		else:
			action_labels[1].modulate = Color.WHITE


func _update_ui() -> void:
	# 更新队友血条
	for i in range(min(3, $BattleManager.party.size())):
		var hero = $BattleManager.party[i]
		var bar = get_node_or_null("UI/PartyHPBar%d" % i)
		if bar:
			bar.value = float(hero.current_hp) / hero.max_hp * 100.0
	
	# 更新敌人血条
	var alive_enemies = $BattleManager.enemies.filter(func(e): return e.is_alive())
	if alive_enemies.size() > 0:
		var enemy = alive_enemies[0]
		enemy_hp_bar.value = float(enemy.current_hp) / enemy.max_hp * 100.0
	else:
		enemy_hp_bar.value = 0
	
	# 更新日志
	if $BattleManager.battle_log.size() > 0:
		log_label.text = "\n".join($BattleManager.battle_log[-5:])


func _on_turn_changed(phase: String) -> void:
	_update_ui()
	if phase == "player":
		selected_action = "attack"
		_update_action_menu()


func _on_battle_ended(result: String) -> void:
	_update_ui()
	status_label.text = "战斗结束！结果: %s" % result
