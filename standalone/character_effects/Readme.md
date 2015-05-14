This script adds two effects to the player or events: shake and rotate
Use this script call to shake the player for 30 frames:

$game_player.shake(0.3, 0.3, 30)

And use this script call to rotate the player 90 degrees in 30 frames:

$game_player.rotate(90, 30)

Or you can force a specific angle:

$game_player.angle = 180
