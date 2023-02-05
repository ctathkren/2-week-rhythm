extends Node2D

func _ready():
    $SpritesButton.animation = "decay"
    $SpritesButton.frame = 3

    $SpritesGlow.animation = "decay"
    $SpritesGlow.frame = 3