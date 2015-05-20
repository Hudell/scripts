class Game_Player < Game_Character
  def do_actual_start_map_event(block_x, block_y, triggers, normal)
    return if $game_map.interpreter.running?
    return if is_tile_checked?(block_x, block_y)

    $game_map.ms_effectus_event_pos[y * $game_map.width + x].each do |event|
      if event.trigger_in?(triggers) && event.normal_priority? == normal
        mark_tile_as_checked(event.x, event.y)
        event.start
      end
    end
  end
end
