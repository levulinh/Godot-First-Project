extends CharacterBody2D
enum COW_STATE {IDLE, WALK}
@export var move_speed : float = 20
@export var idle_time : float = 5
@export var walk_time : float = 2

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var sprite = $Sprite2D
@onready var timer = $Timer
@onready var player = get_node("/root/GameLevel/PlayerCat")

var move_direction : Vector2 = Vector2.ZERO
var current_state : COW_STATE = COW_STATE.IDLE

func _ready():
	var offset_move_time = randf_range(0, 2)
	timer.start(offset_move_time)
	print(name)

func _physics_process(_delta):
	if current_state == COW_STATE.WALK:
		move_direction = position.direction_to(player.position)
		face_the_move_direction()
		velocity = move_direction * move_speed
		move_and_slide()

func face_the_move_direction():
	if move_direction.x < 0:
		sprite.flip_h = true
	elif move_direction.x > 0:
		sprite.flip_h = false

func select_new_direction():
	# const dir_val = [-1, 1]
	# var move_x = dir_val[randi_range(0, 1)]
	# var move_y = dir_val[randi_range(0, 1)]
	# move_direction = Vector2(
	# 	move_x,
	# 	move_y
	# )

	face_the_move_direction()

func pick_new_state():
	if(current_state == COW_STATE.IDLE):
		state_machine.travel("Walk")
		current_state = COW_STATE.WALK
		select_new_direction()
		timer.start(walk_time)
	else:
		state_machine.travel("Idle")
		current_state = COW_STATE.IDLE
		timer.start(idle_time)

func _on_timer_timeout():
	pick_new_state()
