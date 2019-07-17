extends HBoxContainer

signal buttonZ_down
signal buttonX_down
signal buttonC_down


func _on_ZButton_button_down():
	emit_signal("buttonZ_down")


func _on_XButton_button_down():
	emit_signal("buttonX_down")


func _on_CButton_button_down():
	emit_signal("buttonC_down")
