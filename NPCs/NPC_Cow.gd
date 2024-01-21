extends CharacterBody2D

enum COW_STATE { IDLE, BLINK, WALK }

@export var move_speed : float = 20
@export var idle_time : float = 5
@export var walk_time : float = 2

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var sprite = $Sprite2D
@onready var timer = $Timer

var move_direction : Vector2 = Vector2.ZERO
var current_state : COW_STATE = COW_STATE.IDLE

func _ready():
	randomize_timer_start()
	pick_new_state()
	
func randomize_timer_start():
	#randomize the timer's wait time
	timer.wait_time = randi_range(0.1, idle_time)
	timer.start()

func _physics_process(_delta):
	if(current_state == COW_STATE.WALK):
		velocity = move_direction * move_speed
		move_and_slide()

#randommly generates a move direction
#can be either -1, 0, or 1 for x and y

func select_new_direction():
	move_direction = Vector2(
		randi_range(-1,1),
		randi_range(-1,1)
	)
	
	if (move_direction.x < 0):
		sprite.flip_h = true
	elif(move_direction.x > 0):
		sprite.flip_h = false
		
	
#switch from walking to idling
func pick_new_state():
	var min_time = 0.1
	if(current_state == COW_STATE.IDLE):
		select_new_direction()
		if (move_direction.length() > 0 ):
			state_machine.travel("cow_walk")
			current_state = COW_STATE.WALK
			timer.wait_time = randi_range(min_time, walk_time)
			#timer.start(walk_time)
		else:
			timer.wait_time = randi_range(min_time, idle_time)
#	elif(current_state == COW_STATE.IDLE):
#		state_machine.travel("cow_blink")
#		current_state = COW_STATE.BLINK
	elif(current_state == COW_STATE.WALK):
		state_machine.travel("cow_idle")
		current_state = COW_STATE.IDLE
		timer.wait_time = randi_range(min_time, idle_time)
	timer.start()


func _on_timer_timeout():
	pick_new_state();
