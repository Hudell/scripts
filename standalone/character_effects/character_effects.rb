#------------------------------------------------------------
#------------------------------------------------------------
#--------------------  CHARACTER EFFECTS  -------------------
#------------------------------------------------------------
#------------------------------------------------------------
#
# Script created by Hudell
# Version: 1.6
# You're free to use this script on any project

class Game_CharacterBase
  attr_writer :x
  attr_writer :y
  attr_writer :real_x
  attr_writer :real_y
  attr_writer :zoom_x
  attr_writer :zoom_y

  def shake(x_offset = 0.3, y_offset = 0.3, frames = 30)
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

  def flash(duration, alpha = 255, red = 255, green = 255, blue = 255)
    @flash_color = Color.new(red, green, blue, alpha)
    @flash_duration = duration
  end

  def flash_loop(duration, times, alpha = 255, red = 255, green = 255, blue = 255)
    times.times do
      @flash_color = Color.new(red, green, blue, alpha)
      @flash_duration = duration
      duration.times do
        Fiber.yield
      end
    end
  end

  def origin_x=(value)
    @origin_x = value
  end
  def origin_x
    return 0 if @origin_x.nil?
    return @origin_x
  end
  def origin_y=(value)
    @origin_y = value
  end
  def origin_y
    return 0 if @origin_y.nil?
    return @origin_y
  end

  def zoom_x
    @zoom_x || 1
  end

  def zoom_y
    @zoom_y || 1
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

  def clear_flash
    @flash_color = nil
    @flash_duration = 0
  end

  attr_reader :flash_color
  def flash_duration
    return 0 if @flash_duration.nil?
    return @flash_duration
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
    update_origin
    hudell_update_other

    self.angle = character.angle
    update_flash
    update_zoom
  end

  def update_zoom
    self.zoom_x = @character.zoom_x
    self.zoom_y = @character.zoom_y
  end

  def update_flash
    if character.flash_duration > 0
      self.flash(character.flash_color, character.flash_duration)
      character.clear_flash
    end
  end

  def update_origin
    @origin_x = 0 if @origin_x.nil?
    @origin_y = 0 if @origin_y.nil?
    
    if @origin_x != character.origin_x
      @original_ox = self.ox if @original_ox.nil?

      offset_x = (character.origin_x - @origin_x) / 32.0

      character.real_x = character.real_x + offset_x
      character.x = character.real_x
      self.ox = @original_ox + character.origin_x
      self.x = character.screen_x
    end

    if @origin_y != character.origin_y
      @original_oy = self.oy if @original_oy.nil?

      offset_y = (character.origin_y - @origin_y) / 32.0

      character.real_y = character.real_y + offset_y
      character.y = character.real_y
      self.oy = @original_oy + character.origin_y
      self.y = character.screen_y
    end
    
    @origin_x = character.origin_x
    @origin_y = character.origin_y
  end
end
