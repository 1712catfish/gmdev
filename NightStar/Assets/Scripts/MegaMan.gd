extends KinematicBody2D

const PLAYER_RUN = "MegaMan_run"
const PLAYER_IDLE = "MegaMan_idle"
const PLAYER_JUMP = "MegaMan_jump"
const PLAYER_ATTACK = "MegaMan_attack"
const PLAYER_AIR_ATTACK = "MegaMan_airattack"

var walkSpeed = 96
var jumpForce = 192
var gravity = 1024

onready var velocity = Vector2()

onready var sprite = $Sprite
onready var animator = $AnimationPlayer

var isLeftPressed
var isRightPressed
var isJumpPressed
var isAttackPressed = false
var isAttacking = false
var isGrounded
var currentAnimation
	
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	velocity.y += delta * gravity
	Get_input()
	Update()
	velocity = move_and_slide(velocity, Vector2.UP)

func Update():

	# Check if player is on the ground
	isGrounded = is_on_floor()

	# Check update movement based on input
	var vel = Vector2(0, velocity.y)

	if isLeftPressed:
		vel.x = -walkSpeed
		sprite.flip_h = true

	elif isRightPressed:
		vel.x = walkSpeed
		sprite.flip_h = false

	else:
		vel.x = 0

	if isGrounded and not isAttacking:
		if isLeftPressed or isRightPressed:
			ChangeAnimationState(PLAYER_RUN)
		else:
			ChangeAnimationState(PLAYER_IDLE)


	# Check if trying to jump
	if isJumpPressed and isGrounded:
		vel.y += -jumpForce
		isJumpPressed = false
		ChangeAnimationState(PLAYER_JUMP)

	# Assign the the new velocity to the body
	velocity = vel

	# Attack
	if isAttackPressed:
		isAttackPressed = false

		if not isAttacking:
			isAttacking = true

			if isGrounded:
				ChangeAnimationState(PLAYER_ATTACK)
			else:
				ChangeAnimationState(PLAYER_AIR_ATTACK)

			InvokeAttackComplete(0.2)

func Get_input():	
	isLeftPressed = Input.is_key_pressed(KEY_LEFT)
	isRightPressed = Input.is_key_pressed(KEY_RIGHT)
	isJumpPressed = Input.is_key_pressed(KEY_UP)
	isAttackPressed = Input.is_key_pressed(KEY_SPACE)

func ChangeAnimationState(newAnimation):
	if currentAnimation == newAnimation:
		return
	animator.play(newAnimation)
	currentAnimation = newAnimation

func InvokeAttackComplete(seconds):
	yield(get_tree().create_timer(seconds), "timeout")
	isAttacking = false
