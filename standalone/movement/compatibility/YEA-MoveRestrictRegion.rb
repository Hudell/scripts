#Readds the passable? method to the Game_Player class
class Game_Player
  alias game_player_passable_mrr passable?
  def passable?(x, y, d)
    return false if player_region_forbid?(x, y, d)
    return game_player_passable_mrr(x, y, d)
  end
end

#Make sure the script uses the correct step size when checking region_ids
class Game_CharacterBase
  def player_region_forbid?(x, y, d)
    return false unless self.is_a?(Game_Player)
    return false if debug_through?
    region = 0
    case d
    when 1; region = $game_map.region_id((x - my_step_size).floor, (y + my_step_size).floor)
    when 2; region = $game_map.region_id((x + 0).floor, (y + my_step_size).floor)
    when 3; region = $game_map.region_id((x + my_step_size).floor, (y + my_step_size).floor)
    when 4; region = $game_map.region_id((x - my_step_size).floor, (y + 0).floor)
    when 5; region = $game_map.region_id((x + 0).floor, (y + 0).floor)
    when 6; region = $game_map.region_id((x + my_step_size).floor, (y + 0).floor)
    when 7; region = $game_map.region_id((x - my_step_size).floor, (y - my_step_size).floor)
    when 8; region = $game_map.region_id((x + 0).floor, (y - my_step_size).floor)
    when 9; region = $game_map.region_id((x + my_step_size).floor, (y - my_step_size).floor)
    end
    return true if $game_map.all_restrict_regions.include?(region)
    return false if @through
    return $game_map.player_restrict_regions.include?(region)
  end
end
