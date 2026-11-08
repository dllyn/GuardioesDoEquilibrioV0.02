extends Area2D

const SPEED_GAIVOTA : int = 100
var direction_gaivota : int = 1

@onready var visao_gaivota = $VisaoGaivota
var perseguir_player : bool = false
var position_initial_y : float
@onready var gaivota_sprite := $Sprite2D
@onready var sensor_parede := $SensorParede

func _ready(): #No comeco da cena
	body_entered.connect(_on_body_entered)
	position_initial_y = global_position.y
	
func movimento_gaivota(delta: float) -> void: 

	if perseguir_player == false:
		sensor_parede.force_shapecast_update()
		
		if sensor_parede.is_colliding() or global_position.x <= 0 or \
		global_position.x >= 480:
			direction_gaivota *= -1
			gaivota_sprite.flip_h = direction_gaivota < 0
			global_position.x = clamp(global_position.x, 0, 480)
			
			sensor_parede.target_position.x = abs(sensor_parede.target_position.x) * direction_gaivota
			
			global_position.x += direction_gaivota * 2
			
		else:
			global_position.x += direction_gaivota * SPEED_GAIVOTA * delta
		
		global_position.y = lerp(global_position.y, position_initial_y, (SPEED_GAIVOTA/50.0) * delta)
		
	elif perseguir_player == true:
		var player_node = get_tree().get_first_node_in_group("player")
		if player_node:
			var pos_player: Vector2 = player_node.global_position
			global_position = global_position.move_toward(pos_player, SPEED_GAIVOTA * delta)
			
			visao_gaivota.force_shapecast_update()
	perseguir_player = visao_gaivota.is_colliding()
	
	#if perseguir_player == false:
		#global_position.x += direction_gaivota * SPEED_GAIVOTA * delta
		#global_position.y = lerp(global_position.y, position_initial_y, (SPEED_GAIVOTA/50.0) * delta)
	#
	#if ((global_position.x <= 0 or global_position.x >= 480) or sensor_parede.is_colliding()):
		#direction_gaivota *= -1
		#global_position.x = clamp(global_position.x, 0, 480)
		#gaivota_sprite.flip_h = direction_gaivota < 0
	#
	#if perseguir_player == true:
		#var player_node = get_tree().get_first_node_in_group("player")
		#if player_node:
			#var pos_player: Vector2 = player_node.global_position
			#global_position = global_position.move_toward(pos_player,SPEED_GAIVOTA * delta )
#
	#perseguir_player = visao_gaivota.is_colliding()
		

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("Player colidiu com a gaivota")
		
func _physics_process(delta: float) -> void: #Para manter em 60 fps
	movimento_gaivota(delta)
	
