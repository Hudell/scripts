#------------------------------------------------------------
#------------------------------------------------------------
#-------------------  ORANGE CHEAT SYSTEM  ------------------
#------------------------------------------------------------
#------------------------------------------------------------
#
# Script created by Hudell (www.hudell.com)
# You're free to use this script on any project
#
# Requires Orange Input
#
module OrangeCheats
  # Main_Key = :tab
  Main_Key = nil
  
  # 'cheat_code' => switch_id
  Cheat_List = {
  }

  def self.get_key_description(key)
    sym = OrangeInput.key_symbol(OrangeInput.last_triggered_key)
    if sym.nil?
      ''
    else
      sym.to_s
    end
  end

  def self.check_input
    @last_cheat = "" if @last_cheat.nil?

    if Main_Key.nil? || OrangeInput.press?(Main_Key)
      if OrangeInput.triggered_any?
        @last_cheat += get_key_description(OrangeInput.last_triggered_key)

        Cheat_List.keys.each do |key|
          if @last_cheat.end_with?(key)
            @last_cheat = ""

            $game_switches[Cheat_List[key]] = true
            return
          end
        end
      end
    else
      @last_cheat = ""
    end
  rescue NameError
    raise "Orange Cheats Error - Did you include Orange Input?"
  end
end

class Scene_Base
  alias :hudell_orange_cheats_update :update
  def update
    hudell_orange_cheats_update

    OrangeCheats.check_input
  end
end

unless OrangeCheats::Main_Key.nil?
  module Input
    class << self
      alias :hudell_press? :press?
      alias :hudell_trigger? :trigger?
    end

    def self.press?(key)
      if OrangeInput.press?(OrangeCheats::Main_Key)
        false
      else
        hudell_press?(key)
      end
    end

    def self.trigger?(key)
      if OrangeInput.press?(OrangeCheats::Main_Key)
        false
      else
        hudell_trigger?(key)
      end
    end
  end
end
