module OrangePlatforming
  GRAVITY_STRENGTH = 1.0 / 6
  JUMP_STRENGTH = GRAVITY_STRENGTH
  JUMP_TIME = 20
end

module OrangePlatforming_Character
  include OrangePlatforming

  def enable_jump
    return if @jumping

    #Can't jump if it's not touching anything
    return if can_go_down?(@x, @y, false, GRAVITY_STRENGTH) || @y > ($game_map.height - 1.1)

    @jump_time_left = JUMP_TIME
    @jumping = true
    @direction_fix = true
  end

  def apply_gravity
    if @jumping
      #The last few frames are just a delay before the player starts to fall
      if @jump_time_left > 4
        if still_jumping? && can_go_up?(@x, @y, false, JUMP_STRENGTH)
          @y -= JUMP_STRENGTH
          @real_y = @y
        else
          @jump_time_left = 4
        end
      end

      @jump_time_left -= 1
      @jumping = false if @jump_time_left <= 0
      @direction_fix = false
    else
      @gravity_multiplier.times do
        #Make te player fall if there's nothing under it or if he's at the very end of the map (vertically)
        if can_go_down?(@x, @y, false, GRAVITY_STRENGTH) || @y > ($game_map.height - 1.1)
          @y += GRAVITY_STRENGTH
        else
          #If the player isn't at the far end of the tile, move him down a little further
          if hitbox_bottom < hitbox_bottom.ceil
            diff = hitbox_bottom.ceil - hitbox_bottom
            if diff < GRAVITY_STRENGTH && can_go_down?(@x, @y, false, diff)
              @y += diff

              print "moving a little extra: " + diff.to_s + "\n"
            end
          end
        end
      end
      @real_y = @y
    end
  end
end

class Game_Player < Game_Character
  include OrangePlatforming
  include OrangePlatforming_Character

  @jumping = false
  @jump_time_left = 0
  @gravity_multiplier = 1

  alias :hudell_orange_gravity_game_player_move_by_input :move_by_input
  def move_by_input
    return if !movable? || $game_map.interpreter.running?

    down = Input.press?(Input::DOWN)
    up = Input.press?(Input::UP)
    right = Input.press?(Input::RIGHT)
    left = Input.press?(Input::LEFT)

    if can_go_down?(@x, @y, false, GRAVITY_STRENGTH)
      if left
        if can_go_left?(@x, @y, false)
          @x = @x - my_step_size
          @real_x = @x
          @direction = Direction.left if @direction != Direction.left
        end
      elsif right
        if can_go_right?(@x, @y, false)
          @x = @x + my_step_size
          @real_x = @x
          @direction = Direction.right if @direction != Direction.right
        end
      end
    else
      enable_jump if up

      move_straight(Direction.left) if left
      move_straight(Direction.right) if right
    end

    if down
      @gravity_multiplier = 2
    else
      @gravity_multiplier = 1
    end
    apply_gravity
  end

  def still_jumping?
    Input.press?(Input::UP)
  end
end



# class Game_Event < Game_Character
#   include OrangeMovement
#   include Orange_Character

#   def hitbox_x_size
#     0.0
#   end

#   def hitbox_y_size
#     0.0
#   end

#   def hitbox_v_size
#     1.0
#   end

#   def hitbox_h_size
#     1.0
#   end

#   def my_step_size
#     if move_route_forcing
#       1
#     else
#       Step_Size
#     end
#   end

#   alias :hudell_orange_movement_game_event_map_passable? :map_passable?
#   def map_passable?(x, y, d)
#     return hudell_orange_movement_game_event_map_passable?(x, y, d) unless enabled?

#     return module_map_passable?(x, y, d)
#   end

#   alias :orange_movement_game_event_move_straight :move_straight
#   def move_straight(d, turn_ok = true)
#     return orange_movement_game_event_move_straight(d, turn_ok) unless enabled?
#     module_move_straight(d, turn_ok)
#   end

#   alias :orange_movement_game_event_move_diagonal :move_diagonal
#   def move_diagonal(horz, vert)
#     return orange_movement_game_event_move_diagonal(horz, vert) unless enabled?
#     module_move_diagonal(horz, vert)
#   end
# end

# class Game_Event < Game_Character
#   include OrangePlatforming
#   include OrangePlatforming_Character

#   @jumping = false
#   @jump_time_left = 0
#   @gravity_multiplier = 1

#   def still_jumping?
#     Input.press?(Input::UP)
#   end

#   alias :hudell_orange_gravity_game_event_update :update
#   def update
#     @gravity_multiplier = 1
#     apply_gravity
#     hudell_orange_gravity_game_event_update
#   end
# end
