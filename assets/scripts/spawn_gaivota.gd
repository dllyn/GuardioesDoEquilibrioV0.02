extends Node2D

var gaivota_scene = preload("res://assets/scenes/Inimigo_gaivota.tscn")
# Called when the node enters the scene tree for the first time.

var gaivota_spawn_pos = global_position

func _ready():
	
	var gaivota = gaivota_scene.instantiate()
	gaivota.position = gaivota_spawn_pos
	add_child(gaivota)
		
