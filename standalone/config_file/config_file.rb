# ConfigFile for VXAce by Hudell
# Free for non commercial and commercial use
# Contact : brian@hudell.com
# URL: www.hudell.com

module ConfigFile
  SWITCHES_TO_LOAD = []
  VARIABLES_TO_LOAD = []

  @fileName = './Game.ini'

  GetPrivateProfileString   = Win32API.new('kernel32', 'GetPrivateProfileString'  , 'ppppip'      , 'i')
  WritePrivateProfileString = Win32API.new('kernel32', 'WritePrivateProfileString', 'pppp'        , 'i')  

  def self.getValue(section, option_name, defaultValue)
    buffer = [].pack('x256')
    
    print section.to_s + ", " + option_name.to_s + ", " + defaultValue.to_s + "\n"

    value = GetPrivateProfileString.call(section, option_name, defaultValue, buffer, buffer.size, @fileName)
    return buffer[0, value]
  end

  def self.setValue(section, option_name, value)
    WritePrivateProfileString.call(section, option_name, value.to_s, @fileName)
  end

  def self.save_variable(variable_index)
    setValue('variable', variable_index.to_s, $game_variables[variable_index])
  end

  def self.load_variable(variable_index)
    value = getValue('variable', variable_index.to_s, $game_variables[variable_index].to_s)
    $game_variables[variable_index] = value.to_i
  end

  def self.save_switch(switch_index)
    if $game_switches[switch_index]
      value = "1"
    else
      value = "0"
    end

    setValue('switch', switch_index.to_s, value)
  end

  def self.load_switch(switch_index)
    if $game_switches[switch_index]
      value = "1"
    else
      value = 0
    end

    value = getValue('switch', switch_index.to_s, value)

    if value == "1"
      $game_switches[switch_index] = true
    else
      $game_switches[switch_index] = false
    end
  end

  def self.auto_load_stuff
    SWITCHES_TO_LOAD.each do |switch_index|
      load_switch(switch_index)
    end

    VARIABLES_TO_LOAD.each do |variable_index|
      load_variable(variable_index)
    end
  end
end

class Game_System
  alias :global_switches_on_after_load :on_after_load
  def on_after_load
    global_switches_on_after_load
    ConfigFile::auto_load_stuff
  end 
end
