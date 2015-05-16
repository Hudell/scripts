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

You can also change the origin of the rotation, but be careful: When you do this, the character / event won't trigger events or collisions. They will start triggering them again if you set the origin back to 0. Those values are on pixels.

$game_player.origin_x = 25

$game_player.origin_y = 10

Flashing
--------
Use this to flash the character for 10 frames:

$game_player.flash(10)

And this to do a loop of 6 flashes:

$game_player.flash_loop(10, 6)
