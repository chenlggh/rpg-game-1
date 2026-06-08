# 对话框 UI 节点
# 显示 NPC 对话文本，支持选项分支

class_name DialogueBox
extends Control

signal dialogue_finished

# 对话数据
var current_dialogue: DialogueData = null
var current_line_index: int = 0

@onready var speaker_label: Label = $SpeakerLabel
@onready var text_label: Label = $TextLabel
@onready var option_container: VBoxContainer = $OptionContainer

# 打字机效果速度（毫秒/字符）
@export var typewriter_speed: float = 30.0

func start_dialogue(dialogue: DialogueData, start_index: int = 0) -> void:
	current_dialogue = dialogue
	current_line_index = start_index
	_show_line()

func _show_line() -> void:
	if current_dialogue == null:
		_on_finished()
		return
	
	var line = current_dialogue.get_line(current_line_index)
	if line == null:
		_on_finished()
		return
	
	# 显示说话人
	speaker_label.text = line.speaker if line.speaker != "" else ""
	speaker_label.visible = line.speaker != ""
	
	# 打字机效果显示文本
	_type_text(line.text)
	
	# 显示选项（如果有）
	if line.options.size() > 0:
		_show_options(line.options)

func _type_text(text: String) -> void:
	text_label.text = ""
	var index := 0
	
	# 使用定时器实现打字机效果
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = typewriter_speed / 1000.0
	timer.one_shot = true
	timer.timeout.connect(_on_typewriter_tick)
	
	var char_array = text.toCharArray()
	
	func tick():
		if index < char_array.size():
			text_label.text += char_array[index]
			index += 1
			timer.start()
		else:
			timer.queue_free()
	
	tick()

func _on_typewriter_tick() -> void:
	# 打字机下一个字符（由 timer 触发）
	pass

func _show_options(options: Array[DialogueLine.DialogueOption]) -> void:
	option_container.clear()
	for option in options:
		var button = Button.new()
		button.text = option.label
		button.pressed.connect(func(): _on_option_selected(option.next_line_index))
		option_container.add_child(button)

func _on_option_selected(next_index: int) -> void:
	option_container.clear()
	current_line_index = next_index
	_show_line()

func _on_finished() -> void:
	dialogue_finished.emit()
	queue_free()
