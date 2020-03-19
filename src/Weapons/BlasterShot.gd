extends KinematicBody2D
class_name BlasterShot

var speed: int

var velocity = Vector2.ZERO

func _init():
	speed = 20 * global.UNIT_SIZE

func spawn(direction: Vector2) -> void:
	var temp = global_transform
	var scene = get_tree().current_scene
	get_parent().remove_child(self)
	scene.add_child(self)
	global_transform = temp
	velocity = speed * direction

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity * delta)
	if collision != null:
		_on_impact(collision.normal)

func _on_impact(normal: Vector2) -> void:
	velocity = Vector2.ZERO
	$AnimatedSprite.play("hit")
	yield($AnimatedSprite, "animation_finished")
	queue_free()

