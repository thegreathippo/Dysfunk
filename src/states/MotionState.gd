extends FSM
class_name MotionState

class Motion:
	extends State

class OnGround:
	extends Motion

	func is_valid(owner: Object) -> bool:
		return owner.is_grounded()

	func apply_process(owner: Object, delta: float) -> void:
		owner.move_on_ground()

	func apply_input(owner: Object, event: InputEvent) -> void:
		if event.is_action_pressed("jump"):
			owner.jump()

class InAir:
	extends Motion
	
	func is_valid(owner: Object) -> bool:
		return !owner.is_grounded()

	func apply_process(owner: Object, delta: float) -> void:
		owner.move_in_air()

class Idle:
	extends OnGround

	func is_valid(owner: Object) -> bool:
		return .is_valid(owner) &&\
		owner.velocity.x == 0

	func transition(owner: Object) -> Reference:
		if !owner.is_grounded():
			if owner.velocity.y < 0:
				return Jump
			else:
				return Fall
		else:
			return Run

	func enter(owner: Object, previous_state: Reference) -> void:
		owner.anim_player.play("idle")

	func get_name() -> String:
		return "Idle"

class Run:
	extends OnGround

	func is_valid(owner: Object) -> bool:
		return .is_valid(owner) &&\
		owner.velocity.x != 0 

	func transition(owner: Object) -> Reference:
		if !owner.is_grounded():
			if owner.velocity.y < 0:
				return Jump
			else:
				return Fall
		else:
			return Idle

	func enter(owner: Object, previous_state: Reference) -> void:
		owner.anim_player.play("run")

	func get_name() -> String:
		return "Run"

class Jump:
	extends InAir

	func is_valid(owner: Object) -> bool:
		return .is_valid(owner) &&\
		owner.velocity.y < 0

	func transition(owner: Object) -> Reference:
		if owner.is_grounded():
			return Idle
		else:
			return Fall

	func apply_input(owner: Object, event: InputEvent) -> void:
		if event.is_action_released("jump"):
			owner.release_jump()

	func enter(owner: Object, previous_state: Reference) -> void:
		owner.anim_player.play("jump")

	func get_name() -> String:
		return "Jump"

class Fall:
	extends InAir

	func is_valid(owner: Object) -> bool:
		return .is_valid(owner) &&\
		owner.velocity.y >= 0

	func transition(owner: Object) -> Reference:
		if owner.is_grounded():
			return Idle
		else:
			return Jump

	func enter(owner: Object, previous_state: Reference) -> void:
		owner.anim_player.play("fall")

	func get_name() -> String:
		return "Fall"
