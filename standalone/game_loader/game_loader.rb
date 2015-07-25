module GameLoader
  def self.game_index
    @game_index
  end

  def self.load_game(index)
    @game_index = index
    SceneManager.scene.return_scene
    SceneManager.goto(Scene_SaveLoader)
  end

  def self.check_if_save_exists(index)
    file_name = DataManager.make_filename(index)
    return !Dir.glob(file_name).empty?
  end

  def self.save_game(index)
    @game_index = index
    SceneManager.scene.return_scene
    SceneManager.goto(Scene_SaveWriter)
  end

  def self.get_saved_map_id(save_index)
    get_saved_map_id(save_index, :map_id, 0)
  end

  def self.get_saved_map_name(save_index)
    get_save_information(save_index, :map_displayname, '')
  end

  def self.get_saved_gametime(save_index)
    get_save_information(save_index, :playtime_s, '00:00:00')
  end

  def self.get_saved_variable(save_index, variable_index)
    variables = get_save_information(save_index, :variables, [])
    return 0 if variables.nil?

    return variables[variable_index]
  end

  def self.get_save_information(index, information, default_value)
    header = DataManager.load_header(index)

    return default_value if header.nil?
    return default_value if header[information].nil?
    return header[information]
  end
end

class Scene_SaveLoader < Scene_Base
  def start
    create_main_viewport
    SceneManager.scene.fadeout_all
    if DataManager.load_game(GameLoader.game_index)
      Sound.play_load
      $game_system.on_after_special_load
    else
      Sound.play_buzzer
    end

    SceneManager.goto(Scene_Map)
  end
end

class Game_System
  def on_after_special_load
    @bgm_on_save.play unless @bgm_on_save.nil?
    @bgs_on_save.play unless @bgm_on_save.nil?
  end  
end

class Scene_SaveWriter < Scene_Base
  def start
    create_main_viewport
    if DataManager.save_game(GameLoader.game_index)
      Sound.play_save
      SceneManager.goto(Scene_Map)
    else
      Sound.play_buzzer
      SceneManager.goto(Scene_Map)
    end
  end
end

module DataManager
  def self.make_save_header
    header = {}
    header[:characters] = $game_party.characters_for_savefile
    header[:playtime_s] = $game_system.playtime_s
    header[:map_id] = $game_map.map_id
    header[:map_displayname] = $game_map.display_name
    header[:variables] = $game_variables
    header
  end
end