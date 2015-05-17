class Spriteset_Map
  alias :hudell_all_tile_create_pictures :create_pictures
  def create_pictures
    hudell_all_tile_create_pictures
    create_all_tile_pic
  end

  def create_all_tile_pic
    @all_tiles_bitmaps = []
    @all_tiles_pics = []
    @current_all_tiles = []

    @current_display_x4 = nil
    @current_display_y4 = nil
    @current_tile_x4 = nil
    @current_tile_y4 = nil
  end

  alias :hudell_all_tile_update :update
  def update
    hudell_all_tile_update
    update_all_tile_pic
  end

  alias :hudell_all_tile_dispose :dispose
  def dispose
    hudell_all_tile_dispose
    dispose_all_tile_pic
  end

  def dispose_all_tile_pic
    unless @all_tiles_pics.nil?
      @all_tiles_bitmaps.each do |bmp|
        bmp.dispose
      end
      @all_tiles_pics.each do |pic|
        pic.dispose
      end
      @all_tiles_pics = []
      @all_tiles_bitmaps = []
    end
  end

  def tiles_changed?(new_tiles)
    return true if @current_all_tiles.nil?
    return true if new_tiles.count != @current_all_tiles.count
    return true if @current_display_x4 != $game_map.display_x
    return true if @current_display_y4 != $game_map.display_y
    return true if @current_tile_x4 != $game_player.tile_x
    return true if @current_tile_y4 != $game_player.tile_y

    false
  end

  def update_all_tile_pic
    return unless SceneManager::scene_is?(Scene_Map)

    new_tiles = []
    for x in $game_player.x - 5 .. $game_player.x + 5
      for y in $game_player.y - 5 .. $game_player.y + 5
        new_tiles << {:x => x, :y => y}
      end
    end

    if new_tiles.count == 0
      return if @current_all_tiles.nil? || @current_all_tiles.count == 0

      dispose_all_tile_pic
      @current_all_tiles = new_tiles
      @current_display_x4 = $game_map.display_x
      @current_display_y4 = $game_map.display_y
      @current_tile_x4 = $game_player.tile_x
      @current_tile_y4 = $game_player.tile_y
    else
      if tiles_changed?(new_tiles)
        dispose_all_tile_pic unless @current_all_tiles.nil? || @current_all_tiles.count == 0
        @current_all_tiles = new_tiles

        draw_all_tiles(new_tiles)
      end
    end
  end

  def draw_all_tiles(tiles)
    rect_left = Rect.new(0, 0, 4, 32)
    rect_right = Rect.new(28, 0, 4, 32)
    rect_top = Rect.new(0, 0, 32, 4)
    rect_bottom = Rect.new(0, 28, 32, 4)

    blocked_color = Color.new(255, 0, 0, 128)
    free_color = Color.new(0, 255, 0, 128)

    @all_tiles_pics = []
    @all_tiles_bitmaps = []

    tiles.each do |tile|
      pic = Sprite.new(@viewport2)
      bmp = Bitmap.new(32, 32)

      if $game_player.can_go_left?(tile[:x], tile[:y])
        bmp.fill_rect(rect_left, free_color)
      else
        bmp.fill_rect(rect_left, blocked_color)
      end
      if $game_player.can_go_right?(tile[:x], tile[:y])
        bmp.fill_rect(rect_right, free_color)
      else
        bmp.fill_rect(rect_right, blocked_color)
      end
      if $game_player.can_go_up?(tile[:x], tile[:y])
        bmp.fill_rect(rect_top, free_color)
      else
        bmp.fill_rect(rect_top, blocked_color)
      end
      if $game_player.can_go_down?(tile[:x], tile[:y])
        bmp.fill_rect(rect_bottom, free_color)
      else
        bmp.fill_rect(rect_bottom, blocked_color)
      end

      pic.bitmap = bmp

      x, y = (tile[:x] - $game_map.display_x) * 32, (tile[:y] - $game_map.display_y) * 32
      pic.x = x
      pic.y = y

      @all_tiles_pics << pic
      @all_tiles_bitmaps << bmp
    end

    @current_display_x4 = $game_map.display_x
    @current_display_y4 = $game_map.display_y
    @current_tile_x4 = $game_player.tile_x
    @current_tile_y4 = $game_player.tile_y
  end
end
