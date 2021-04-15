extends Control

var dialog = [
	'This is Placeholder 1',
	'This is Placeholder 2',
	'This is Placeholder 3',
	'This is Placeholder 4',
	'This is Placeholder 5',
	'This is Placeholder 6',
	'This is Placeholder 7',
	'This is Placeholder 8'
	]

var dialog_index = 0 
var finished = false

func _ready():
	load_dialog()
	

func _process(delta):
	$Indicator.visible = finished
	if Input.is_action_just_pressed("ui_accept"):
		load_dialog()

func load_dialog():
	if dialog_index < dialog.size():
		finished = false
		$RichTextLabel.bbcode_text = dialog[dialog_index]
		$RichTextLabel.percent_visible = 0
		$Tween.interpolate_property(
			$RichTextLabel, "percent_visible", 0 , 1 , 1 ,
			Tween.TRANS_LINEAR , Tween.EASE_IN_OUT
		)
		$Tween.start()
	else:
		queue_free()
	dialog_index += 1





func _on_Tween_tween_completed(object: Object, key: NodePath) -> void:
	finished = true
