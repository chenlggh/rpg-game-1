# 对话数据结构
# 管理所有 NPC 对话文本和分支逻辑

class_name DialogueData
extends Resource

# 对话条目
var lines: Array[DialogueLine] = []

# 对话线数据结构
class DialogueLine:
	var speaker: String = ""
	var text: String = ""
	var options: Array[DialogueOption] = []
	
	class DialogueOption:
		var label: String = ""
		var next_line_index: int = 0
		var condition: String = ""  # 可选条件，如 "has_item:药水"

# 添加对话线
func add_line(speaker: String, text: String) -> int:
	var line = DialogueLine.new()
	line.speaker = speaker
	line.text = text
	lines.append(line)
	return lines.size() - 1

# 添加选项
func add_option(line_index: int, label: String, next_index: int) -> void:
	if line_index < lines.size():
		var option = DialogueLine.DialogueOption.new()
		option.label = label
		option.next_line_index = next_index
		lines[line_index].options.append(option)

# 获取指定行
func get_line(index: int) -> DialogueLine:
	if 0 <= index and index < lines.size():
		return lines[index]
	return null

# 获取行数
func get_line_count() -> int:
	return lines.size()
