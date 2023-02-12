extends KinematicBody2D
class_name Actor

const FLOOR_NORMAL: = Vector2.UP

export var speed: = Vector2(650.0, 1400.0)
export var gravity: = 3000.0
export var sprint_mult: = Vector2(1.1, 1.1)
export var health: = 10

var _velocity: = Vector2.ZERO
