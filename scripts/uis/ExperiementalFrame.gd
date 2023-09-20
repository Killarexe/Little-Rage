extends CanvasLayer
class_name ExpirementalFrame

@onready var dialog: ConfirmationDialog = $ConfirmationDialog

var on_confirmed: Callable = func():pass
var on_canceled: Callable = func():pass

func pop(on_confirmed: Callable, on_canceled: Callable):
	self.on_confirmed = on_confirmed
	self.on_canceled = on_canceled
	dialog.popup_centered()

func _on_confirmation_dialog_canceled():
	on_canceled.call()

func _on_confirmation_dialog_confirmed():  
	on_confirmed.call()
