extends HBoxContainer

signal file_new
signal file_open
signal file_save
signal file_quit

signal edit_undo
signal edit_redo
signal edit_cut
signal edit_copy
signal edit_paste

func _on_FileMenuButton_file_new():
	emit_signal("file_new")

func _on_FileMenuButton_file_open():
	emit_signal("file_open")

func _on_FileMenuButton_file_quit():
	emit_signal("file_quit")

func _on_FileMenuButton_file_save():
	emit_signal("file_save")


func _on_EditMenuButton_edit_undo():
	emit_signal("edit_undo")

func _on_EditMenuButton_edit_redo():
	emit_signal("edit_redo")

func _on_EditMenuButton_edit_cut():
	emit_signal("edit_cut")

func _on_EditMenuButton_edit_copy():
	emit_signal("edit_copy")

func _on_EditMenuButton_edit_paste():
	emit_signal("edit_paste")
