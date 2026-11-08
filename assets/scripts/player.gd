extends CharacterBody2D

const JUMP_SPEED : float = 200.0
const SPEED : float = 300.0
const JUMP_VELOCITY : float = -400.0
@onready var _animation_player = $AnimatedPlayer #Animação da Nina

var is_jumping : bool = false

@onready var wall_slide_speed : float = 50.0
@onready var wall_jump_force : Vector2 = Vector2(100, -300)

var is_wall_sliding : bool = false
var wall_direction : int = 0

@onready var ray_right: RayCast2D = $Ray_right
@onready var ray_left: RayCast2D = $Ray_left

var is_wall_colliding : bool = false
#Para ver se está colidindo com a parede

func _ready()-> void:
	add_to_group("player")
	
	
	
func _process(_delta: float) -> void: #Carregar sempre, usar função
	_set_animation() #Animações do player
func _physics_process(delta: float) -> void: #Movimentação Base e virar player
# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		is_jumping = false
# Mecanica jump.
	if Input.is_action_just_pressed("ui_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		is_jumping = true
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction : float = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
#Mecanica Wall Jump

	var is_touching_left_wall = ray_left.is_colliding()
	var is_touching_right_wall = ray_right.is_colliding()

	if (is_touching_left_wall or is_touching_right_wall) and not is_on_floor() and velocity.y > 0: 
		start_wall_slide(is_touching_left_wall, is_touching_right_wall)
	elif is_wall_sliding and not (is_touching_left_wall or is_touching_right_wall):
		stop_wall_slide()

	if is_wall_sliding:
		if (Input.is_action_just_pressed("ui_jump") or Input.is_action_just_pressed("ui_jump") and Input.is_action_just_pressed("ui_up")):
			velocity = Vector2(wall_jump_force.x * wall_direction, wall_jump_force.y )
			stop_wall_slide()
			#if Input.is_action_just_pressed("ui_jump") and \
			#(Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right")):
				#velocity = Vector2((wall_jump_force.x + 400 ) * wall_direction, wall_jump_force.y )
				#stop_wall_slide()
				#("para os lados")
			#elif Input.is_action_just_pressed("ui_jump") and \
			#(Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right")) and\
			#Input.is_action_just_pressed("ui_up"):
				#print("Diagonal")
				#velocity = Vector2((wall_jump_force.x + 400 ) * wall_direction, (wall_jump_force.y + 300)  )
				#stop_wall_slide()
		#elif Input.is_action_just_pressed("ui_jump") and \
		#(Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right")):
			#velocity = Vector2((wall_jump_force.x + 400 ) * wall_direction, wall_jump_force.y )
			#stop_wall_slide()
			#("para os lados")
		#elif Input.is_action_just_pressed("ui_jump") and \
		#(Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right")) and\
		#Input.is_action_just_pressed("ui_up"):
			#print("Diagonal")
			#velocity = Vector2((wall_jump_force.x + 400 ) * wall_direction, (wall_jump_force.y + 300)  )
			#stop_wall_slide()

	move_and_slide() #Detecta os movimentos básicos para o player
	
func _set_animation(): #Função da animação do Player e girar 
	var direction : float = Input.get_axis("ui_left", "ui_right") #Variavel da direção do player
	if direction:
			_animation_player.play("Run") #Para ativar animação corre
			_animation_player.flip_h = direction < 0 #Faz girar o player no eixo X
	if is_on_floor() and not Input.is_anything_pressed(): #Para a animação de "parado"
		_animation_player.play("Idle")
		is_jumping = false
#	se o player não tiver no chão e a outra animação acabar, então:	
	if not is_on_floor() and _animation_player.animation_finished: #Para a animação de cair
		_animation_player.play("Fall") #Movimento de cair
	if is_jumping == true:
		_animation_player.play("Jump")
		
#Wall Jump e Wall slide Player
	if is_wall_sliding:
		_animation_player.play("WallSlide")

	
#Wall Jump e Wall slide Player
func start_wall_slide(left,_right):
	is_wall_sliding = true
	velocity.y = min(velocity.y, wall_slide_speed) #Valor minimo, com o min"
	wall_direction = 1 if left else -1
	
func stop_wall_slide():
	is_wall_sliding = false
	wall_direction = 0
