extends Camera2D

func _ready():
	add_to_group("camera")

func shake(magnitude: float):
	shake_magnitude = magnitude

# Set variable called shake
var shake_magnitude = 0

func _process(delta):
	if shake_magnitude >= 0.1:
		offset = Vector2(rand_range(-shake_magnitude, shake_magnitude),
						 rand_range(-shake_magnitude, shake_magnitude));
		shake_magnitude *= 0.9;
