extends FSM
class_name PlayerMotion

class Motion:
	extends State

class OnGround:
	extends Motion

	func apply_process(owner: Object, delta: float) -> void:
		owner.move_on_ground()

	func apply_input(owner: Object, event: InputEvent) -> void:
		if event.is_action_pressed("jump"):
			owner.jump()

class InAir:
	extends Motion

class Idle:
	extends OnGround

	func transition(owner: Object) -> Reference:
		if !owner.is_grounded():
			if owner.velocity.y < 0:
				return Jump
			elif owner.velocity.y >= 0:
				return Fall
		elif owner.velocity.x != 0:
			return Run
		return Idle

class Run:
	extends OnGround

class Jump:
	extends InAir

	func transition(owner: Object) -> Reference:
		if owner.is_grounded():
			return Idle
		elif owner.velocity.y >= 0:
			return Fall
		return Jump

	func apply_input(owner: Object, event: InputEvent) -> void:
		if event.is_action_released("jump"):
			owner.release_jump()

class Fall:
	extends InAir

	func transition(owner: Object) -> Reference:
		if owner.is_grounded():
			return Idle
		elif owner.velocity.y < 0:
			return Jump
		return Fall

