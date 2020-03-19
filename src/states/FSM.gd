extends Reference
class_name FSM

var default_state: State

var _current_state: State
var _previous_state: State

func _init() -> void:
	_current_state = State.new()
	_previous_state = State.new()


func handle_process(owner: Object, delta: float) -> void:
	_current_state.apply_process(owner, delta)
	var transition = _current_state.transition(owner)
	if transition != _current_state.get_script():
		set_state(owner, transition)

func handle_input(owner: Object, event: InputEvent) -> void:
	_current_state.apply_input(owner, event)

func set_state(owner: Object, new_state: Script) -> void:
	_previous_state = _current_state
	_current_state = new_state.new()
	_previous_state.exit(owner)
	_current_state.enter(owner)
