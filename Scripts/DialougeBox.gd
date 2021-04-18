class_name DialogBox
extends Control

# NOTE: Why titelize this text? Makes it hard to read imho?
var tutoial_dialog = [
	'This forest is powered by the divine tree.',
	'Protect it with your axe and by placing towers',
	'You can place only 7 towers at once!',
	'Use them wisely and remember...',
	'The tree must be protected at all costs',
	'Use WASD to move and spacebar to attack',
	'Start the wave when ready. Good luck!'
	]

var dialog_index = 0 
var finished = false

onready var text_label = $Panel/RichTextLabel
onready var tween = $Tween
onready var indicator: Sprite = $Panel/Indicator

# Signal that gets emitted when there is a dialog displayed and user skipped it
signal dialog_skipped()

func show_text(text: String):
	visible = true
	indicator.visible = false
	text_label.bbcode_text = text
	text_label.percent_visible = 0
	tween.interpolate_property(
		text_label, "percent_visible", 0 , 1 , 1 ,
		Tween.TRANS_LINEAR , Tween.EASE_IN_OUT
	)
	tween.start()

func show_multiline(lines: Array):
	for text in lines:
		show_text(text)
		yield(self, "dialog_skipped")
	hide_dialog()

func show_single_line(text: String):
	show_text(text)
	yield(self, "dialog_skipped")
	hide_dialog()

func _ready():
	hide_dialog()
	tween.connect("tween_all_completed", self, "animation_completed")

func animation_completed():
	indicator.visible = true

func _input(event):
	if event.is_action_pressed("ui_accept"):
		emit_signal("dialog_skipped")

func hide_dialog():
	visible = false

func start_tutorial():
	show_multiline(tutoial_dialog)

func _on_Tween_tween_completed(object: Object, key: NodePath) -> void:
	finished = true
