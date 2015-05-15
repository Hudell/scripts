#------------------------------------------------------------
#------------------------------------------------------------
#--------------------  CHARACTER EFFECTS  -------------------
#------------------------------------------------------------
#------------------------------------------------------------
#
# Script created by Hudell
# Version: 1.1
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
  
  #Using offset to change positions may break the collision check, so use it with caution
  def offset_x_position(offset)
    offset = offset % 32
    return if offset <= 0
    
    change = 1.0 / 32.0 * offset
    @x = @x.floor + change
  end

  def offset_y_position(offset)
    offset = offset % 32
    return if offset <= 0
    
    change = 1.0 / 32.0 * offset
    @y = @y.floor + change
  end  
end

class Sprite_Character < Sprite_Base
  alias :hudell_update_other :update_other
  def update_other
    hudell_update_other
    self.angle = character.angle
  end
end
