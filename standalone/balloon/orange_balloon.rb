#------------------------------------------------------------
#------------------------------------------------------------
#---------------------  ORANGE BALLOON---  ------------------
#------------------------------------------------------------
#------------------------------------------------------------

module OrangeBalloon
  EXCLAMATION = 1
  QUESTION = 2
  MUSIC = 3
  HEART = 4
  ANGER = 5
  SWEAT = 6
  COBWEB = 7
  SILENCE = 8
  BULB = 9
  ZZZ = 10

  def self.show_balloon(balloon_id)
    show_balloon_at_event(0, balloon_id)
  end

  def self.show_balloon_at_event(event_id, balloon_id, keep_showing = true)
    event = $game_map.interpreter.get_character(event_id)
    return if event.nil?
    if keep_showing
      event.loop_balloon = true
    end
    event.balloon_id = balloon_id
  end

  def self.hide_balloon(event_id = 0)
    event = $game_map.interpreter.get_character(event_id)
    return if event.nil?
    event.loop_balloon = false
    event.halt_balloon = true
  end
end

class Game_CharacterBase
  attr_accessor :loop_balloon
  attr_accessor :halt_balloon
  alias hudell_orange_balloon_init_public_members init_public_members
  def init_public_members
    hudell_orange_balloon_init_public_members
    @loop_balloon = false
  end
end

class Sprite_Character < Sprite_Base
  def update_balloon
    if @character.halt_balloon
      @character.halt_balloon = false
      @balloon_duration = 0
      end_balloon
      return
    end

    if @balloon_duration > 0
      @balloon_duration -= 1
      if @balloon_duration == 0 && !@character.loop_balloon.nil? && @character.loop_balloon
        @balloon_duration = 8 * balloon_speed + balloon_wait
      end

      if @balloon_duration > 0 and !@balloon_sprite.nil?
        @balloon_sprite.x = x
        @balloon_sprite.y = y - height
        @balloon_sprite.z = z + 200
        sx = balloon_frame_index * 32
        sy = (@balloon_id - 1) * 32
        @balloon_sprite.src_rect.set(sx, sy, 32, 32)
      else
        end_balloon
      end
    end
  end
end
