extends CharacterBody2D

@export var move_speed : float = 100
@export var starting_direction : Vector2 = Vector2(0, 1)
# parameters/idle/blend_position

@onready var animation_tree = $AnimationTree

func _ready():
	animation_tree.set("parameters/idle/blend_position", starting_direction)

func _physics_process(_delta):
	#Get Input Direction
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)

	print(input_direction)
	
	# Update Velocity
	velocity = input_direction * move_speed
	
	# Move and Slide function uses velocity of character body to move character on map
	move_and_slide()	
