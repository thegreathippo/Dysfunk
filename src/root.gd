extends Node2D

var _statemachine

func _ready() -> void:
	_statemachine = PlayerMotion.new()
	_statemachine.set_state(self, PlayerMotion.Idle)

func _physics_process(delta: float) -> void:
	_statemachine.handle_process(self, delta)

func _input(event):
	_statemachine.handle_input(self, event)
