extends CharacterBody2D
class_name PlayerComponent

signal on_win(time: Array[int], death_count: int)
signal on_death(death_count: int)

@export_category("Player components")
@export var controller: PlayerControllerComponent
@export var death_component: DeathComponent
@export var timer: PlayerTimer
