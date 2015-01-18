module Hudell_Zelda_Save_System
  NUMBER_OF_SAVES = 3
  NAME_MAX_CHARACTERS = 10

  def self.chosen_slot=(value)
    @chosen_slot = value
  end
  def self.chosen_slot
    @chosen_slot
  end
  
  def self.delete_save
    return if @chosen_slot.nil?
    return if @chosen_slot < 0
    
    DataManager::delete_save_file(@chosen_slot)
  end
end

class Scene_File < Scene_MenuBase
  def item_max
    return Hudell_Zelda_Save_System::NUMBER_OF_SAVES
  end
  def visible_max
    return 3
  end  

  def create_help_window
    @help_window = Zelda_Window_Help.new(1)
    @help_window.set_text(help_window_text)
  end  
  
  def ensure_cursor_visible
    self.top_index = index if index < top_index
    self.bottom_index = index if index > bottom_index
    
    @savefile_windows.each do |window|
      window.refresh
    end
  end
  
  def create_savefile_viewport
    @savefile_viewport = Viewport.new
    @savefile_viewport.rect.y = @help_window.height
    @savefile_viewport.rect.height -= @help_window.height
    @savefile_viewport.rect.x = 0
    #@savefile_viewport.rect.width -= @savefile_viewport.rect.x
    #@savefile_viewport.rect.height = Graphics.height - (@help_window.height * 3)
  end  
  
  def start
    super
    create_help_window
    create_savefile_viewport
    create_savefile_windows
    create_options_windows
    init_selection
  end  
  
  def savefile_height
    saves_height = Graphics.height - (@help_window.height * 3)
    #@savefile_viewport.rect.height / visible_max
    return saves_height / visible_max
  end
    
  def create_options_windows
    @savefile_windows << Window_CopySave.new(savefile_height * 3, 0, @savefile_viewport)
    @savefile_windows << Window_DeleteSave.new(savefile_height * 3, 1, @savefile_viewport)
  end
  
  alias :hudell_zelda_save_screen_update_savefile_selection :update_savefile_selection
  def update_savefile_selection
    hudell_zelda_save_screen_update_savefile_selection if @block_cursor.nil?
  end
  
  def cursor_down(wrap)
    @index = (@index + 1) % (Hudell_Zelda_Save_System::NUMBER_OF_SAVES + 2) if @index < item_max - 1 || wrap
    ensure_cursor_visible
    
  end

  def cursor_up(wrap)
    @index = (@index - 1 + (Hudell_Zelda_Save_System::NUMBER_OF_SAVES + 2)) % (Hudell_Zelda_Save_System::NUMBER_OF_SAVES + 2) if @index > 0 || wrap
    ensure_cursor_visible
  end
end

class Game_System
  def load_playtime
    Graphics.frame_count = @frames_on_save
  end
  
  def reset_playtime
    @frames_on_save = 0
    Graphics.frame_count = 0
  end
  
  def save_playtime
    @frames_on_save = Graphics.frame_count
  end
end

class Window_SaveOption < Window_Base
  attr_accessor :selected
  
  def standard_padding
    return 8
  end  
  
  def window_height
    fitting_height(1)
  end

  def initialize(y, option_index, viewport)
    @viewport = viewport
    
    y += @viewport.oy + fitting_height(1)
    y += fitting_height(option_index) if option_index > 0
    super(0, y, Graphics.width, window_height)
    refresh
    @selected = false
  end  
  
  def refresh
    contents.clear
    change_color(normal_color, SceneManager::scene_is?(Scene_Load))
  end
end

class Window_CopySave < Window_SaveOption
  def refresh
    super
    draw_text(10, 0, contents_width, line_height, 'Copy Save File')
  end
end

class Window_DeleteSave < Window_SaveOption
  def refresh
    super
    draw_text(10, 0, contents_width, line_height, 'Delete Save File')
  end
end

class Window_EmptyOption < Window_SaveOption
  def window_height
    fitting_height(1) * 2
  end
end

class Scene_Load < Scene_File
	def help_window_text
		'Please select a file'
	end
  
  def on_savefile_ok
    super
    
    if @index <  Hudell_Zelda_Save_System::NUMBER_OF_SAVES
      if DataManager.load_game(@index)
        on_load_success
      else
        Hudell_Zelda_Save_System::chosen_slot = @index
        start_empty_file
      end
    elsif @index == Hudell_Zelda_Save_System::NUMBER_OF_SAVES
      #Copy save file
      Hudell_Zelda_Save_System::chosen_slot = -1
      SceneManager::call(Scene_CopySave)
    else
      #Delete save file
      Hudell_Zelda_Save_System::chosen_slot = -1
      SceneManager::call(Scene_DeleteSave)
    end
  end
  
  def start_empty_file
    DataManager::setup_new_game
    if $game_party.members.length == 0
      Sound.play_buzzer
      return
    end
    
    SceneManager.call(Scene_NewName)
    SceneManager.scene.prepare($game_party.members[0].id, Hudell_Zelda_Save_System::NAME_MAX_CHARACTERS)
  end
end

class Scene_NewName < Scene_Name
  def on_input_ok
    @actor.name = @edit_window.name
    
    $game_system.reset_playtime
    DataManager::save_game(Hudell_Zelda_Save_System::chosen_slot)
    return_scene
  end
end

class Scene_AdditionalSave < Scene_File
  
  def create_options_windows
    @savefile_windows << Window_EmptyOption.new(savefile_height * 3, 0, @savefile_viewport)
  end
  
  def cursor_down(wrap)
    @index = (@index + 1) % item_max if @index < item_max - 1 || wrap
    ensure_cursor_visible
  end

  def cursor_up(wrap)
    @index = (@index - 1 + item_max) % item_max if @index > 0 || wrap
    ensure_cursor_visible
  end
end

class Scene_DeleteSave < Scene_AdditionalSave
  alias :hudell_zelda_save_system_start_delete :start
  def start
    hudell_zelda_save_system_start_delete
    create_confirm_window
  end
  
  def create_confirm_window
    @confirm_window = Window_ConfirmDeletion.new
    @confirm_window.hide.deactivate
    @confirm_window.set_handler(:yes, method(:on_confirm_deletion))
    @confirm_window.set_handler(:cancel, method(:on_cancel_deletion))
  end
  
  def confirm_deletion
    @confirm_window.show
    @confirm_window.activate
    @confirm_window.select(0)
    
    @block_cursor = true
  end
  
  def on_confirm_deletion
    Hudell_Zelda_Save_System::delete_save
    return_scene
  end
  
  def on_cancel_deletion
    return_scene
  end
  
  def help_window_text
    'Delete which file?'
  end
  
  def first_savefile_index
    0
  end
  
  def on_savefile_ok
    super
    
    if @index < Hudell_Zelda_Save_System::NUMBER_OF_SAVES
      if DataManager.load_game(@index)
        Hudell_Zelda_Save_System::chosen_slot = @index
        confirm_deletion
      else
        Sound.play_buzzer
      end      
      
    end
  end  
end

class Scene_CopySave < Scene_AdditionalSave
  alias :hudell_zelda_save_system_start_copy :start
  def start
    hudell_zelda_save_system_start_copy
    create_confirm_window
  end
  
  def create_confirm_window
    @confirm_window = Window_ConfirmCopy.new
    @confirm_window.hide.deactivate
    @confirm_window.set_handler(:cancel, method(:on_cancel_copy))
    
    Hudell_Zelda_Save_System::NUMBER_OF_SAVES.times do |index|
      next if Hudell_Zelda_Save_System::chosen_slot == index
      
      file_sym = ('file_' + index.to_s).to_sym
      define_singleton_method(file_sym) do
        DataManager::copy_save_file(Hudell_Zelda_Save_System::chosen_slot, index)
        return_scene
      end
      
      @confirm_window.set_handler(file_sym, method(file_sym))
    end    
  end

  def help_window_text
    'Copy which file?'
  end
  
  def on_cancel_copy
    return_scene
  end
  
  def first_savefile_index
    0
  end
  
  def confirm_copy
    @confirm_window.show
    @confirm_window.activate
    @confirm_window.refresh
    @confirm_window.select(0)
    
    @block_cursor = true
  end
  
  def on_savefile_ok
    super
    
    if @index < Hudell_Zelda_Save_System::NUMBER_OF_SAVES
      if DataManager.load_game(@index)
        Hudell_Zelda_Save_System::chosen_slot = @index
        confirm_copy
      else
        Sound.play_buzzer
      end
    end
  end
end

class Scene_Save < Scene_File
  alias :hudell_zelda_save_system_on_savefile_ok_save :on_savefile_ok
	def on_savefile_ok
		super
    
    return hudell_zelda_save_system_on_savefile_ok_save if @index < Hudell_Zelda_Save_System::NUMBER_OF_SAVES

    Sound.play_buzzer
	end	

	def help_window_text
		'Please select a file'
	end
  
  def on_savefile_ok
    super
    if DataManager.save_game(@index)
      on_save_success
    else
      Sound.play_buzzer
    end
  end  
end

class Window_SaveFile < Window_Base
  def initialize(height, index)
    super(30, index * height, Graphics.width - 30, height)
    @file_index = index
    refresh
    @selected = false
  end

  def standard_padding
    return 8
  end  
  
  def viewport_top_index
    SceneManager.scene.top_index
  end
  
  def refresh
    contents.clear
    
    #Do not paint windows currently out of screen
    if (@file_index < viewport_top_index) or (@file_index > viewport_top_index + 2)
      self.windowskin = nil
      return
    end
    self.windowskin = Cache.system("Window")
    
    change_color(normal_color)
    file_name = 'File ' + (@file_index + 1).to_s + ': '
    name = ''
    draw_party_characters(220, line_height + 32)
    
    draw_text(10, 0, 200, line_height, file_name)
    
    header = DataManager.load_header(@file_index)
    gold = ''
    hp = '0'
    hp_name = Vocab::hp
    mp = '0'
    mp_name = Vocab::mp
    
    if header
      if !header[:name].nil?
        name = header[:name]
      end
      
      if !header[:gold_s].nil?
        gold = header[:gold_s] + ' G'
      end
      
      draw_text(210, 0, 200, line_height, name)
      draw_text(Graphics.width - 250, 0, 200, line_height, gold, 2)
      
      if !header[:hp].nil?
        hp = header[:hp]
      end
      
      bottom_line = contents.height - line_height
      medium_line = bottom_line - line_height
      
      draw_text(210, medium_line, 200, line_height, hp_name + ': ' + hp.to_s)
      draw_text(210, bottom_line, 200, line_height, mp_name + ': ' + mp.to_s)
      
      draw_playtime(Graphics.width - 250, bottom_line, 200, 2)
    end
  end
  
  def update_cursor
    if @selected
      cursor_rect.set(0, 0, contents_width, contents_height)
    else
      cursor_rect.empty
    end
  end  
end

module DataManager
  def self.make_save_header
    header = {}
    header[:characters] = $game_party.characters_for_savefile
    header[:playtime_s] = $game_system.playtime_s
    header[:gold_s] = $game_party.gold.to_s
    
    if $game_party.members.length > 0
      header[:name] = $game_party.members[0].name
      header[:hp] = $game_party.members[0].hp
      header[:mp] = $game_party.members[0].mp
    else
      header[:name] = ''
      header[:hp] = 0
      header[:mp] = 0
    end
    
    header
  end  
  
  def self.copy_save_file(origin_index, destination_index)
    load_game(origin_index)
    $game_system.load_playtime
    save_game(destination_index)
  end
end

class Zelda_Window_Help < Window_Help
  def standard_padding
    return 8
  end  
end

class Window_ConfirmDeletion < Window_Command
  def initialize
    super(Graphics.width - window_width, Graphics.height - window_height)
    select_symbol(:cancel)
    self.openness = 0
    open    
  end
  
  def make_command_list
    add_command('  Delete this save file', :yes)
    add_command('  Quit', :cancel)
  end
  
  def window_width
    Graphics.width
  end

  def standard_padding
    return 8
  end  
  
  def window_height
    fitting_height(1) * 2
  end
end

class Window_ConfirmCopy < Window_Command
  def initialize
    super(Graphics.width - window_width, Graphics.height - window_height)
    select_symbol(:cancel)
    self.openness = 0
    open
  end
  
  def make_command_list
    Hudell_Zelda_Save_System::NUMBER_OF_SAVES.times do |index|
      next if Hudell_Zelda_Save_System::chosen_slot == index
      
      name = ''
      file_name = 'File ' + (index + 1).to_s
      
      header = DataManager::load_header(index)
      if !header.nil? and !header[:name].nil?
        name = ': ' + header[:name]
      end
      
      add_command(file_name + name, ('file_' + index.to_s).to_sym)
    end
    
    add_command('Quit', :cancel)
  end
  
  def window_width
    Graphics.width * 0.4
  end
  
  def standard_padding
    return 8
  end
  
  def window_height
    fitting_height(Hudell_Zelda_Save_System::NUMBER_OF_SAVES)
  end
end

class Window_TitleCommand < Window_Command
  def continue_enabled
    return true
  end
end
