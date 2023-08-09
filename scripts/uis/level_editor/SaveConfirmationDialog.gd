extends ConfirmationDialog

func _ready():
	connect("canceled", on_canceled)
	connect("confirmed", on_confirmed)

func on_canceled():
	emit_signal("custom_action", "cancel")

func on_confirmed():
	emit_signal("custom_action", "accept")
