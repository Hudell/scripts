#------------------------------------------------------------
#------------------------------------------------------------
#-----------------------  HOLD ITEM  ------------------------
#------------------------------------------------------------
#------------------------------------------------------------
#
# Script created by Hudell
# Version: 1.0
# You're free to use this script on any project

module HoldItem
  Variable_Index = 192

  Character_X_Offset = 13
  Character_Y_Offset = 52

  def self.item_id
    $game_variables[Variable_Index]
  end
end

class Spriteset_Map
  alias :hudell_hold_item_create_pictures :create_pictures
  def create_pictures
    hudell_hold_item_create_pictures
    create_item_pic
  end

  def create_item_pic
    @item_bitmap = nil
    @item_pic = nil
    @current_item_id = 0
  end

  alias :hudell_hold_item_update :update
  def update
    hudell_hold_item_update
    update_item_pic
  end

  alias :hudell_hold_item_dispose :dispose
  def dispose
    hudell_hold_item_dispose
    dispose_item_pic
  end

  def dispose_item_pic
    unless @item_pic.nil?
      @item_bitmap.dispose
      @item_pic.dispose
      @item_bitmap = nil
      @item_pic = nil
    end
  end

  def update_item_pic
    return unless SceneManager::scene_is?(Scene_Map)
    
    if HoldItem.item_id != @current_item_id
      if HoldItem.item_id > 0
        unless @item_pic.nil?
          dispose_item_pic
        end

        @current_item_id = HoldItem.item_id
        item = $data_items[HoldItem.item_id]
        draw_icon(item.icon_index, 0, 0)
      else
        dispose_item_pic
      end
    end

    unless @item_pic.nil?
      @item_pic.x = $game_player.screen_x - HoldItem::Character_X_Offset
      @item_pic.y = $game_player.screen_y - HoldItem::Character_Y_Offset

      if $game_player.pattern % 2 == 1
        @item_pic.y -= 1
      end
    end
  end

  def draw_icon(icon_index, x, y)
    bitmap = Cache.system("Iconset")
    rect = Rect.new(icon_index % 16 * 24, icon_index / 16 * 24, 24, 24)

    if @item_pic.nil?
      @item_pic = Sprite.new(@viewport2)
    end

    if @item_bitmap.nil?
      @item_bitmap = Bitmap.new(24, 24)
    end

    @item_bitmap.blt(x, y, bitmap, rect, 255)
    @item_pic.bitmap = @item_bitmap
  end  
end
