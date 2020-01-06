extends MenuButton

signal edit_undo
signal edit_redo
signal edit_cut
signal edit_copy
signal edit_paste

enum EEditMenu {
	Undo,Redo,
	Cut,Copy,Paste
}

func _ready():
	var popup:PopupMenu = get_popup()
	popup.add_item("Undo",EEditMenu.Undo,KEY_MASK_CTRL | KEY_Z)
	popup.add_item("Redo",EEditMenu.Redo,KEY_MASK_CTRL | KEY_Y)
	popup.add_separator()
	popup.add_item("Cut",EEditMenu.Cut,KEY_MASK_CTRL | KEY_X)
	popup.add_item("Copy",EEditMenu.Copy,KEY_MASK_CTRL | KEY_C)
	popup.add_item("Paste",EEditMenu.Paste,KEY_MASK_CTRL | KEY_V)
	popup.connect("id_pressed",self,"_on_id_pressed")

func _on_id_pressed(id):
	match id:
		EEditMenu.Undo:
			emit_signal("edit_undo")
		EEditMenu.Redo:
			emit_signal("edit_redo")
		EEditMenu.Cut:
			emit_signal("edit_cut")
		EEditMenu.Copy:
			emit_signal("edit_copy")
		EEditMenu.Paste:
			emit_signal("edit_paste")