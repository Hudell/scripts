class Scene_File < Scene_MenuBase
  alias :hudell_zelda_save_system_create_menu_cursors :create_menu_cursors
  def create_menu_cursors
    hudell_zelda_save_system_create_menu_cursors
    
    @savefile_windows.each do |window|
      create_cursor_sprite(window)
    end
  end
  
  alias :hudell_zelda_save_system_update :update
  def update
    hudell_zelda_save_system_update
    update_menu_cursors
  end
  
  def update_menu_cursors
    @menu_cursors.each { |cursor| cursor.update }
  end  
end

class Sprite_MenuCursor < Sprite_Base
  alias :hudell_zelda_save_system_visible_case :visible_case
  def visible_case
    return hudell_zelda_save_system_visible_case if @window.is_a?(Window_Selectable)
    
    return @window.selected
  end
end
