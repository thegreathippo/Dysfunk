extends Reference
class_name State

func transition(owner: Object) -> Reference:
	return self.get_script()

func enter(owner: Object) -> void:
	pass

func exit(owner: Object) -> void:
	pass
	
func apply_process(owner: Object, delta: float) -> void:
	pass
	
func apply_input(owner: Object, event: InputEvent) -> void:
	pass
