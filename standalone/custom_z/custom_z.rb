class Game_Event < Game_Character
  def get_config(regex, default)
    return default if @list.nil?

    @list.each do |command|
      if command.code == 108 || command.code == 408
        begin
          result = command.parameters[0].scan(regex)
          unless result.nil?
            value = result[0][0].to_i
            return value
          end
        rescue
        end
      end
    end

    default
  end

  def z_config
    if @z_config.nil?
      regex = /z\_config_*=_*(.*)$/
      @z_config = get_config(regex, 0)
    end

    @z_config
  end

  def z_config=(value)
    @z_config = value
  end

  def screen_z
    (@priority_type * 100) + z_config
  end

  def viewport_config
    if @viewport_config.nil?
      regex = /viewport\_config_*=_*(.*)$/
      @viewport_config = get_config(regex, 1)
    end

    @viewport_config    
  end

end

class Spriteset_Map
  def get_viewport_by_number(number)
    case number
    when 2
      @viewport2
    when 3
      @viewport3
    else
      @viewport1
    end
  end

  def create_characters
    @character_sprites = []
    $game_map.events.values.each do |event|
      sprite = Sprite_Character.new(get_viewport_by_number(event.viewport_config), event)
      @character_sprites.push(sprite)
    end
    $game_map.vehicles.each do |vehicle|
      @character_sprites.push(Sprite_Character.new(@viewport1, vehicle))
    end
    $game_player.followers.reverse_each do |follower|
      @character_sprites.push(Sprite_Character.new(@viewport1, follower))
    end
    @character_sprites.push(Sprite_Character.new(@viewport1, $game_player))
    @map_id = $game_map.map_id
  end

  def update_pictures
    $game_map.screen.pictures.each do |pic|
      the_viewport = get_viewport_by_number(pic.viewport_number)

      @picture_sprites[pic.number] ||= Sprite_Picture.new(the_viewport, pic)

      if @picture_sprites[pic.number].viewport != the_viewport
        @picture_sprites[pic.number].dispose
        @picture_sprites[pic.number] = Sprite_Picture.new(the_viewport, pic)
      end

      @picture_sprites[pic.number].update
    end
  end
end

class Game_Picture
  attr_writer :z
  attr_writer :viewport_number

  def z
    if @z.nil?
      number
    else
      @z
    end
  end

  def viewport_number
    @viewport_number = 2 if @viewport_number.nil?

    @viewport_number
  end
end

class Sprite_Picture < Sprite
  alias :hudell_custom_pictures_z_value_sprite_picture_update_position :update_position
  def update_position
    hudell_custom_pictures_z_value_sprite_picture_update_position
    self.z = @picture.z
  end
end
