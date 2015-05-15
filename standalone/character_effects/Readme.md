Hudell Character Effects
========================

This script adds some effects to the player or events.

Shaking
-------
Use this script call to shake the player for 30 frames:

$game_player.shake(0.3, 0.3, 30)

Rotating
--------
And use this script call to rotate the player 90 degrees in 30 frames:

$game_player.rotate(90, 30)

Or you can force a specific angle:

$game_player.angle = 180

Flashing
--------
Use this to flash the character for 10 frames:

$game_player.flash(10)

And this to do a loop of 6 flashes:

$game_player.flash_loop(10, 6)
