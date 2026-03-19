extends CharacterBody3D

const SPEED = 20.0
const JUMP_VELOCITY = 10.5
const CAMERA_SENSE = 0.001

#

@onready var Head: Node3D = $Node3D
@onready var camera: Camera3D = $Node3D/Camera3D


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _unhandled_input(event: InputEvent) -> void:
	# it the escape key
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	# Mouse look only when captured
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		Head.rotate_y(-event.relative.x * CAMERA_SENSE)
		camera.rotate_x(-event.relative.y * CAMERA_SENSE)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(100))


func _input(event: InputEvent) -> void:
	# Re-capture cursor on mouse click
	if event is InputEventMouseButton and event.pressed:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Change the input map  
	var input_dir := Input.get_vector("a", "d", "w", "s")
	var direction := (Head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction != Vector3.ZERO:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = 0.0
		velocity.z = 0.0

	move_and_slide()
