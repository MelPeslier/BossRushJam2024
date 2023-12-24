class_name Parameters
extends CanvasLayer

enum MyMouseMode {
	NORMAL,
	CONFINED
}

const v_syncs = {
	V_SYNC_DISABLED = DisplayServer.VSYNC_DISABLED,
	V_SYNC_ENABLED = DisplayServer.VSYNC_ENABLED,
	V_SYNC_ADAPTATIVE = DisplayServer.VSYNC_ADAPTIVE,
	V_SYNC_MAILBOX = DisplayServer.VSYNC_MAILBOX,
}

const screen_anchors = {
	CENTER = Vector2(1, 1),
	RIGHT = Vector2(0, 1),
	LEFT = Vector2(2, 1),
	BOT = Vector2(1, 0),
	LEFT_BOT = Vector2(2, 0),
	RIGHT_BOT = Vector2(0, 0),
	TOP = Vector2(1, 2),
	LEFT_TOP = Vector2(2, 2),
	RIGHT_TOP = Vector2(0, 2),
}

const display_modes = {
	FULL_SCREEN = [
		DisplayServer.WINDOW_MODE_FULLSCREEN,
	],
	WINDOWED = [
		DisplayServer.WINDOW_MODE_WINDOWED,
		[DisplayServer.WINDOW_FLAG_BORDERLESS, false],
	],
	WINDOWED_BORDERLESS = [
		DisplayServer.WINDOW_MODE_WINDOWED,
		[DisplayServer.WINDOW_FLAG_BORDERLESS, true],
	],
}

const resolutions: Array[Vector2i] = [
	Vector2i( 960, 540 ),
	Vector2i( 1920, 1080 ),
	Vector2i( 3840, 1080 ),
]

const framerates: Array[int] = [
	30, 60, 75, 144
]

const PRIVATE_BUS_START: String = "_"


@export var section_buttons: HBoxContainer

@export_category("Sections Contents")
@export var section_contents: PanelContainer

@export_group("Game")
@export var game_content: VBoxContainer

@export_group("Display")
@export var display_content: VBoxContainer
@export var display_mode_value: MenuButton
@export var display_screen_value: MenuButton
@export var v_sync_value: MenuButton
@export var resolution_value: MenuButton
@export var anchor_value: MenuButton
@export var framerate_limit_value: MenuButton

@export_group("Audio")
@export var audio_content: VBoxContainer

@export_group("Controls")
@export var controls_content: VBoxContainer


var display_mode: String
var screen_anchor: String
var resolution: Vector2i
var actual_screen: int
var v_sync: String
var framerate: int


func _ready() -> void:
	_connect_buttons()
	_init_audio_content()
	_init_display_content()


#region *** Display ***
func _init_display_content() -> void:
	#_load_saved_settings else defaults
	#FIXME _on_selectede shouldnt be called here, but values (and text from lists )must be set from saved settings
	resolution_value.get_popup().id_pressed.connect( _on_resolution_value_selected )
	_update_resolution_options()
	_on_resolution_value_selected(0)

	anchor_value.get_popup().id_pressed.connect( _on_anchor_value_selected )
	_update_screen_anchor_options()
	_on_anchor_value_selected(0)

	display_mode_value.get_popup().id_pressed.connect( _on_display_mode_value_selected )
	_update_display_mode_options()
	_on_display_mode_value_selected(0)

	display_screen_value.get_popup().id_pressed.connect( _on_display_screen_value_selected )
	_update_display_screen_options()
	_on_display_screen_value_selected(0)

	v_sync_value.get_popup().id_pressed.connect( _on_v_sync_value_selected )
	_update_v_sync_options()


#region Resolution
func _update_resolution_options() -> void:
	resolution_value.get_popup().clear()
	var monitor_size : Vector2i = DisplayServer.screen_get_size(actual_screen)
	for res: Vector2i in resolutions:
		if res <= monitor_size:
			var title: String = str(res.x) + " x " + str(res.y)
			resolution_value.get_popup().add_item(title)
			if not resolution:
				resolution = res

func _on_resolution_value_selected(_id: int) -> void:
	resolution = resolutions[_id]
	resolution_value.text = str(resolution.x) + " x " + str(resolution.y)
	_set_display()

func _set_resolution() -> void:
	DisplayServer.window_set_size(resolution)
#endregion

#region Anchor
func _update_screen_anchor_options() -> void:
	anchor_value.get_popup().clear()
	for key: String in screen_anchors.keys():
		anchor_value.get_popup().add_item(key)

func _on_anchor_value_selected(_id: int) -> void:
	var _key :String = screen_anchors.keys()[_id]
	anchor_value.text = _key
	screen_anchor = screen_anchors.get(_key)
	_set_anchor()

func _set_anchor() -> void:
	var _size := resolution
	var _usable_rect := DisplayServer.screen_get_usable_rect(actual_screen)
	var _new_pos := _usable_rect.size - _size
	_new_pos.x = _new_pos.x - int( _new_pos.x * screen_anchors.get(screen_anchor).x / 2 ) + _usable_rect.position.x
	_new_pos.y = _new_pos.y - int( _new_pos.y * screen_anchors.get(screen_anchor).y / 2 ) + _usable_rect.position.y
	DisplayServer.window_set_position(_new_pos)
#endregion

#region Mode
func _update_display_mode_options() -> void:
	display_mode_value.get_popup().clear()
	for key: String in display_modes:
		display_mode_value.get_popup().add_item(key)

func _on_display_mode_value_selected(_id: int) -> void:
	var _key :String = display_modes.keys()[_id]
	display_mode_value.text = _key
	display_mode = _key
	_set_display()

func _set_display_mode() -> void:
	for _option in display_modes.get(display_mode):
		if _option is DisplayServer.WindowMode:
			DisplayServer.window_set_mode( _option )
		elif _option is Array:
			if _option[0] is DisplayServer.WindowFlags and _option[1] is bool:
				DisplayServer.window_set_flag( _option[0], _option[1] )
#endregion

#region Screen
func _update_display_screen_options() -> void:
	var available_screens = DisplayServer.get_screen_count()
	for i: int in available_screens:
		var item: String = "DISPLAY" + " " + str( i + 1 )
		display_screen_value.get_popup().add_item(item)
	if not actual_screen:
		actual_screen = DisplayServer.get_primary_screen()

func _on_display_screen_value_selected(_id: int) -> void:
	actual_screen = _id
	display_screen_value.text = "DISPLAY" + " " + str( actual_screen + 1 )
	_set_display()

func _set_screen() -> void:
	DisplayServer.window_set_current_screen(actual_screen)
	_update_resolution_options()
#endregion

#region V-sync
func _update_v_sync_options() -> void:
	v_sync_value.get_popup().clear()

func _on_v_sync_value_selected(_id: int) -> void:
	var _key: String = v_syncs.keys()[_id]
	v_sync_value.text = _key
	v_sync = _key
	_set_v_sync()

func _set_v_sync() -> void:
	DisplayServer.window_set_vsync_mode( v_syncs.get(v_sync) )
#endregion

func _set_display() -> void:
	_set_screen()
	_set_resolution()
	_set_anchor()
	_set_display_mode()
#endregion


#region Audio
func _init_audio_content() -> void:
	for item in audio_content.get_children():
		item.queue_free()

	var audio_params: PackedScene = load("res://ui/menus/templates/volume_sliders/my_audio_params.tscn")
	for _bus_index: int in AudioServer.bus_count:
		var _bus_name := AudioServer.get_bus_name(_bus_index)
		if not _bus_name.begins_with(PRIVATE_BUS_START):
			var _audio_params: MyAudioParams = audio_params.instantiate() as MyAudioParams
			_audio_params.bus_index = _bus_index
			audio_content.add_child(_audio_params)
			_audio_params.label.text = _bus_name
#endregion


#region Parameter Buttons
func _connect_buttons() -> void:
	for button: MyButton in section_buttons.get_children():
		button.button_down.connect(Sfx.on_button_down)
		button.mouse_entered.connect(Sfx.on_mouse_entered)
	_on_game_button_down()


func _on_game_button_down() -> void:
	_disable_sections()
	game_content.visible = true


func _on_display_button_down() -> void:
	_disable_sections()
	display_content.visible = true


func _on_audio_button_down() -> void:
	_disable_sections()
	audio_content.visible = true


func _on_controls_button_down() -> void:
	_disable_sections()
	controls_content.visible = true


func _disable_sections() -> void:
	for section: VBoxContainer in section_contents.get_children():
		section.visible = false
#endregion
