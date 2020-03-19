extends Reference
class_name State

func is_valid(owner: Object) -> bool:
	return true

func get_next_state(owner: Object) -> Reference:
	return self.get_class()

func enter(owner: Object, previous_state: Reference) -> void:
	pass

func exit(owner: Object, new_state: Reference) -> void:
	pass
	
func apply_process(owner: Object, delta: float) -> void:
	pass
	
func apply_input(owner: Object, event: InputEvent) -> void:
	pass

func get_name() -> String:
	return "State"

func get_class():
	return self.get_script()
