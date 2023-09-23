extends CharacterBody2D

@export var move_speed : float = 100
@export var starting_direction : Vector2 = Vector2(0, 1)


@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

func _ready():
	animation_tree.set("parameters/Idle/blend_position", starting_direction)

func _physics_process(_delta):
	#Get input direction
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	#update animation
	update_animation_parameters(input_direction)
	
	#update velocity
	velocity = input_direction * move_speed
	
	#move and slide function
	move_and_slide()
	
	pick_new_state()
	
func update_animation_parameters(move_input : Vector2):
	#dont change if no move input
	if(move_input != Vector2.ZERO):
		animation_tree.set("parameters/Walk/blend_position", move_input)
		animation_tree.set("parameters/Idle/blend_position", move_input)
		
#change animation state
func pick_new_state():
	if(velocity != Vector2.ZERO):
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")

