# 玩家移动单元测试
# 运行方式: godot --headless --test scripts/tests/test_player_movement.gd

extends SceneTree

func _init():
	var root = PackedScene.new().instantiate()
	get_root().add_child(root)
	
	var test_scene = preload("res://scripts/tests/test_player_movement.tscn").instantiate()
	root.add_child(test_scene)
	
	# 运行测试后退出
	await test_scene.tests_finished
	quit(0)
