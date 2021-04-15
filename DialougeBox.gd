extends Control

var dialog = [
	'This Forest Is Powerd By The Divine Tree',
	'Protect It With Your Towers And your Handy Axe',
	'Each Wave You Will Be Able To Place Another Tower',
	'Use Them Wisely And Remember...',
	'The Tree Must be Protected At All Costs',
	'Use WASD To Move And Spacebar To Attack'
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
