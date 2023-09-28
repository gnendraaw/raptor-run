extends VBoxContainer

@onready var start_button = $StartButton
@onready var exit_button = $ExitButton


# Called when the node enters the scene tree for the first time.
func _ready():
	start_button.pressed.connect(_on_start_button_pressed)
	exit_button.pressed.connect(_on_exit_button_pressed)

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/World.tscn")

func _on_exit_button_pressed():
	get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
