extends CharacterBody2D

signal player_died

@export var gravity = 1600
@export var jump_power = 600

@onready var sprite = $AnimatedSprite2D
@onready var jump_sound = $JumpSound
@onready var camera = $"/root/World/Camera2D"
@onready var death_sound = $DeathSound
@onready var collision_shape = $CollisionShape2D

var active = true
var jumps_remaining = 2
var was_jumping = false
var jump_pitch = 1.0

func _ready():
    print("hello world")

func _physics_process(delta):
    velocity.y += gravity * delta

    if active:
        # Update camera position
        camera.position = position

        # Reset the player after jumping
        if was_jumping and is_on_floor():
            was_jumping = false
            jumps_remaining = 2
            sprite.play("run")
            jump_pitch = 1.0

        # Handle jumping
        if Input.is_action_just_pressed("jump") and jumps_remaining > 0:
            jumps_remaining -= 1
            was_jumping = true
            velocity.y = -jump_power

            if jumps_remaining == 1:
                sprite.play("jump")
            else:
                sprite.play("double jump")
            
            jump_sound.set_pitch_scale(jump_pitch)
            jump_sound.play()
            jump_pitch += 0.2

    move_and_slide()

func die():
    death_sound.play()
    sprite.play("death")
    collision_shape.set_deferred("disabled", true)
    active = false
    emit_signal("player_died")