extends Control

signal dialogue_finished

@onready var dialogue_label: RichTextLabel = $HBoxContainer/VBoxContainer/RichTextLabel
@onready var portrait_anim: AnimatedSprite2D = $HBoxContainer/SpeakerParent/PortraitAnim

var _lines: PackedStringArray = PackedStringArray()
var _index: int = 0
var _active: bool = false

func _ready() -> void:
	hide()
	set_process_unhandled_input(false)
	portrait_anim.hide()

# Now accepts: dialogue pages + animated portrait data
func open_lines(
	lines: PackedStringArray,
	portrait_frames: SpriteFrames = null,
	portrait_animation: StringName = &"default",
	portrait_speed: float = 1.0
) -> void:
	if lines.is_empty():
		return

	_lines = lines
	_index = 0
	_active = true

	_set_portrait(portrait_frames, portrait_animation, portrait_speed)
	_show_current()

	show()
	set_process_unhandled_input(true)

func _set_portrait(frames: SpriteFrames, anim: StringName, speed: float) -> void:
	if frames == null:
		portrait_anim.hide()
		portrait_anim.stop()
		return

	portrait_anim.sprite_frames = frames
	portrait_anim.speed_scale = speed

	# If the requested animation doesn't exist, fall back safely
	if portrait_anim.sprite_frames.has_animation(anim):
		portrait_anim.animation = anim
	else:
		portrait_anim.animation = &"default"

	portrait_anim.show()
	portrait_anim.play()

func _show_current() -> void:
	dialogue_label.text = _lines[_index]

func _unhandled_input(event: InputEvent) -> void:
	if not _active:
		return

	if event.is_action_pressed("dialogue_next"):
		get_viewport().set_input_as_handled()
		advance()

func advance() -> void:
	_index += 1
	if _index >= _lines.size():
		close()
	else:
		_show_current()

func close() -> void:
	_active = false
	hide()
	set_process_unhandled_input(false)
	portrait_anim.stop()
	emit_signal("dialogue_finished")
