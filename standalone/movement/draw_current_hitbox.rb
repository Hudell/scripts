class Spriteset_Map
  alias :hudell_current_position_create_picture :create_pictures
  def create_pictures
    hudell_current_position_create_picture
    create_current_position_pic
  end

  def create_current_position_pic
    @current_position_bitmap = nil
    @current_position_pic = nil
    @current_position_x = 0
    @current_position_y = 0

    @current_display_x3 = nil
    @current_display_y3 = nil
  end

  alias :hudell_current_position_update :update
  def update
    hudell_current_position_update
    update_current_position_pic
  end

  alias :hudell_current_position_dispose :dispose
  def dispose
    hudell_current_position_dispose
    dispose_current_position_pic
  end

  def dispose_current_position_pic
    unless @current_position_pic.nil?
      @current_position_bitmap.dispose
      @current_position_pic.dispose

      @current_position_bitmap = nil
      @current_position_pic = nil
    end
  end

  def tile_changed?(x, y)
    return true if @current_position_x != x
    return true if @current_position_y != y
    return true if @current_display_x3 != $game_map.display_x
    return true if @current_display_y3 != $game_map.display_y

    false
  end

  def update_current_position_pic
    return unless SceneManager::scene_is?(Scene_Map)

    new_x = $game_player.float_x + $game_player.hitbox_x_size
    new_y = $game_player.float_y + $game_player.hitbox_y_size

    if tile_changed?(new_x, new_y)
      dispose_current_position_pic unless @current_position_pic.nil?
      @current_position_x = new_x
      @current_position_y = new_y

      draw_position(new_x, new_y)
    end
  end

  def draw_position(new_x, new_y)
    h_size = ($game_player.hitbox_h_size * 32).floor
    v_size = ($game_player.hitbox_v_size * 32).floor
    rect = Rect.new(0, 0, h_size, v_size)

    @current_position_pic = Sprite.new(@viewport2)
    @current_position_bitmap = Bitmap.new(h_size, v_size)

    @current_position_bitmap.fill_rect(rect, Color.new(255, 255, 0, 128))
    @current_position_pic.bitmap = @current_position_bitmap

    x, y = (new_x - $game_map.display_x) * 32, (new_y - $game_map.display_y) * 32
    @current_position_pic.x = x
    @current_position_pic.y = y

    @current_display_x3 = $game_map.display_x
    @current_display_y3 = $game_map.display_y
  end
end
