extends CharacterBody2D

signal player_died

@export var gravity = 1600
@export var jump_power = 600

@onready var sprite = $AnimatedSprite2D
@onready var jump_sound = $JumpSound
@onready var camera = $"/root/World/Camera2D"
@onready var death_sound = $DeathSound
@onready var collision_shape = $CollisionShape2D
@onready var game = $"/root/World"
@onready var shoot_sound = $ShootSound
@onready var projectile_position = $ProjectilePosition

var projectile = preload("res://scenes/projectile.tscn")
var active = true
var jumps_remaining = 2
var was_jumping = false
var jump_pitch = 1.0
var ammo = 3

func _ready():
    sprite.animation_finished.connect(_on_animation_finished)

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

func _input(event):
    if event.is_action_pressed("fire") and ammo > 0:
        var projectile_instance = projectile.instantiate()
        projectile_instance.position = projectile_position.global_position
        game.add_child(projectile_instance)
        shoot_sound.play()
        sprite.play("shoot")
        ammo -= 1

func die():
    death_sound.play()
    sprite.play("death")
    collision_shape.set_deferred("disabled", true)
    active = false
    emit_signal("player_died")

func _on_animation_finished():
    if sprite.animation == "shoot":
        sprite.play("run")

func add_ammo(amount):
    ammo += amount