#------------------------------------------------------------
#------------------------------------------------------------
#--------------------  CHARACTER EFFECTS  -------------------
#------------------------------------------------------------
#------------------------------------------------------------
#
# Script created by Hudell
# Version: 1.0
# You're free to use this script on any project

class Game_CharacterBase
  def shake(x_offset, y_offset, frames)
    (frames / 6).times do
      @x += x_offset
      @y += y_offset
      3.times do
        Fiber.yield
      end
      @x -= x_offset
      @y -= y_offset
      3.times do
        Fiber.yield
      end
    end
  end
   
  def rotate(angle, frames)
    @angle = 0 if @angle.nil?

    angle_per_frame = 1.0 * angle / frames

    frames.times do
      @angle += angle_per_frame
      @angle = @angle % 360
      Fiber.yield
    end
  end

  def angle
    return 0 if @angle.nil?
    return @angle
  end
  
  def angle=(value)
    @angle = value
  end

  def clear_rotation
    @angle = 0
  end
end

class Sprite_Character < Sprite_Base
  alias :hudell_update_other :update_other
  def update_other
    hudell_update_other
    self.angle = character.angle
  end
end
