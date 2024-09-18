extends CanvasLayer
class_name ExpirementalFrame

@onready var dialog: ConfirmationDialog = $ConfirmationDialog

var on_confirmed: Callable = func():pass
var on_canceled: Callable = func():pass

func pop(on_confirmed_lambda: Callable, on_canceled_lambda: Callable) -> void:
	on_confirmed = on_confirmed_lambda
	on_canceled = on_canceled_lambda
	dialog.popup_centered()

func _on_confirmation_dialog_canceled() -> void:
	on_canceled.call()

func _on_confirmation_dialog_confirmed() -> void:
	on_confirmed.call()
