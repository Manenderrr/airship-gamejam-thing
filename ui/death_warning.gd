class_name DeathWarning
extends Control

@export var message: Label
@export var too_low_message: String = "Слишком низко!"
@export var too_high_message: String = "Слишком высоко!"

@export var timer: Label
@export var bar: ProgressBar

var time: float
@export var duration: float = 5.0

signal on_timeout

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(message, "message is not set")
	assert(timer, "timer is not set")
	assert(bar, "bar is not set")

	#set_process(false)
func _process(delta: float) -> void:
	if time <= 0:
		on_timeout.emit()
		stop()

	timer.text = str(round).pad_decimals(10)
	bar.value = time

	time -= delta

func stop() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	set_process(false)
	hide()
func initiate() -> void:
	time = duration
	bar.max_value = time
	set_process(true)
	show()
func initiate_too_low() -> void:
	initiate()
	message.text = too_low_message
func initiate_too_high() -> void:
	initiate()
	message.text = too_high_message
