class_name DeathWarning
extends Control

@export var message: Label
@export var too_low_message: String = "Слишком низко!"
@export var too_high_message: String = "Слишком высоко!"

@export var timer: Label
@export var bar: ProgressBar

var time: float
@export var duration: float = 5.0

var counting: bool = false

signal on_timeout

func _ready() -> void:
	assert(message, "message is not set")
	assert(timer, "timer is not set")
	assert(bar, "bar is not set")
func _process(delta: float) -> void:
	if not counting: return

	if time <= 0:
		on_timeout.emit()
		stop()

	timer.text = str(time).pad_decimals(1)
	bar.value = time

	time -= delta

func stop() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	counting = false
	hide()
func initiate() -> void:
	time = duration
	bar.max_value = time
	counting = true
	show()
func initiate_too_low() -> void:
	initiate()
	message.text = too_low_message
func initiate_too_high() -> void:
	initiate()
	message.text = too_high_message
