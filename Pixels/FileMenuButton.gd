extends MenuButton

signal file_new
signal file_open
signal file_save
signal file_quit

enum EFileMenu {
	New,Open,Save,
	Quit
}

func _ready():
	var popup:PopupMenu = get_popup()
	popup.add_item("New",EFileMenu.New,KEY_MASK_CTRL | KEY_N)
	popup.add_item("Open",EFileMenu.Open,KEY_MASK_CTRL | KEY_O)
	popup.add_item("Save",EFileMenu.Save,KEY_MASK_CTRL | KEY_S)
	popup.add_separator()
	popup.add_item("Quit",EFileMenu.Quit,KEY_MASK_ALT | KEY_F4)
	popup.connect("id_pressed",self,"_on_id_pressed")

func _on_id_pressed(id):
	match id:
		EFileMenu.New:
			emit_signal("file_new")
		EFileMenu.Open:
			emit_signal("file_open")
		EFileMenu.Save:
			emit_signal("file_save")
		EFileMenu.Quit:
			emit_signal("file_quit")