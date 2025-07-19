extends Node
class_name ButtonList

signal button_toggled(index: int)

@export var buttons: Array[Button]

func _ready() -> void:
  for index in range(0, buttons.size()):
    var button: Button = buttons[index]
    if !button.is_node_ready():
      await button.ready
    button.toggle_mode = true
    button.toggled.connect(
      func(toggled_on: bool):
        if toggled_on:
          on_button_toggled(index)
    )

func select(index: int) -> void:
  if index > buttons.size():
    return
  buttons[index].button_pressed = true
  on_button_toggled(index)

func on_button_toggled(index: int) -> void:
  for i in range(0, buttons.size()):
    if i == index:
      continue
    buttons[i].button_pressed = false
  button_toggled.emit(index)
