extends Node2D
class_name Blaster

var shot: PackedScene
var rate_of_fire: int

var _ticks = 0

onready var muzzle = $Muzzle

func _init():
	shot = preload("res://src/Weapons/BlasterShot.tscn")
	rate_of_fire = 10

func fire():
	_ticks += 1
	if _ticks == rate_of_fire:
		_ticks = 0
		_fire()

func _fire():
	var instance = shot.instance()
	muzzle.add_child(instance)
	var direction = get_parent().get_parent().scale.x
	instance.spawn(Vector2(1, 0) * direction)
