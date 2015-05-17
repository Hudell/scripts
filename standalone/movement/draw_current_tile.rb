class Spriteset_Map
  alias :hudell_current_tile_create_picture :create_pictures
  def create_pictures
    hudell_current_tile_create_picture
    create_current_tile_pic
  end

  def create_current_tile_pic
    @current_tile_bitmap = nil
    @current_tile_pic = nil
    @current_tile_x = 0
    @current_tile_y = 0

    @current_display_x = nil
    @current_display_y = nil
  end

  alias :hudell_current_tile_update :update
  def update
    hudell_current_tile_update
    update_current_tile_pic
  end

  alias :hudell_current_tile_dispose :dispose
  def dispose
    hudell_current_tile_dispose
    dispose_current_tile_pic
  end

  def dispose_current_tile_pic
    unless @current_tile_pic.nil?
      @current_tile_bitmap.dispose
      @current_tile_pic.dispose

      @current_tile_bitmap = nil
      @current_tile_pic = nil
    end
  end

  def tile_changed?(x, y)
    return true if @current_tile_x != x
    return true if @current_tile_y != y
    return true if @current_display_x != $game_map.display_x
    return true if @current_display_y != $game_map.display_y

    false
  end

  def update_current_tile_pic
    return unless SceneManager::scene_is?(Scene_Map)

    new_x = $game_player.x
    new_y = $game_player.y

    if tile_changed?(new_x, new_y)
      dispose_current_tile_pic unless @current_tile_pic.nil?
      @current_tile_x = new_x
      @current_tile_y = new_y

      draw_current_tile(new_x, new_y)
    end
  end

  def draw_current_tile(new_x, new_y)
    rect = Rect.new(0, 0, 32, 32)

    @current_tile_pic = Sprite.new(@viewport1)
    @current_tile_bitmap = Bitmap.new(32, 32)

    @current_tile_bitmap.fill_rect(rect, Color.new(0, 0, 255, 128))
    @current_tile_pic.bitmap = @current_tile_bitmap

    x, y = (new_x - $game_map.display_x) * 32, (new_y - $game_map.display_y) * 32
    @current_tile_pic.x = x
    @current_tile_pic.y = y

    @current_display_x = $game_map.display_x
    @current_display_y = $game_map.display_y
  end
end
