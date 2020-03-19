extends Reference
class_name FSM

var _current_state: State
var _previous_state: State

func _init() -> void:
	_current_state = State.new()
	_previous_state = State.new()

func handle_process(owner: Object, delta: float) -> void:
	_current_state.apply_process(owner, delta)
	if not _current_state.is_valid(owner):
		var state_class = _current_state.get_next_state(owner)
		set_state(owner, state_class)

func handle_input(owner: Object, event: InputEvent) -> void:
	_current_state.apply_input(owner, event)

func set_state(owner: Object, state_class: Script) -> void:
	_previous_state = _current_state
	_current_state = state_class.new()
	_previous_state.exit(owner, _current_state.get_class())
	_current_state.enter(owner, _previous_state.get_class())

func is_state(state_class: Script) -> bool:
	return _current_state.get_class() == state_class

func was_state(state_class: Script) -> bool:
	return _previous_state.get_class() == state_class

