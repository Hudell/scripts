#------------------------------------------------------------
#------------------------------------------------------------
#-----------------  ORANGE MOVEMENT SYSTEM  -----------------
#------------------------------------------------------------
#------------------------------------------------------------
#
# Script created by Hudell
# Version: 2.2
# You're free to use this script on any project
#
# Change Log:
#
# v2.2: 2015-05-24
# => Fixed a problem where events could sometimes walk over the player
#
# v2.1: 2015-05-20
# => Added a new setting: Block_Repeated_Event_Triggering
#
# v2.0: 2015-05-17
# => Completely remade the tileset collision check
# => Implemented hitboxes for the player and follower
#
# v1.9: Improved followers movement
#
# v1.8: Added option to enable / disable the whole script using a switch, fixed a problem where followers wouldn't walk
#
# v1.7: Changed the way that the player will walk when using forced Move Routes
#
# v1.6: Fixed a problem where the game could crash if the jump feature was disabled
#
# v1.5: Added a new setting to disable diagonal movement
#
# v1.4: Fixed a problem with the Auto_Fall feature when used together with pixel movement
#
# v1.3: Fixed a problem where sometimes the player would be able to enter an impassable tile
#
# v1.2: Added several new configs: Auto_Avoid_Diagonally, Auto_Avoid_Walking_Around, Auto_Avoid_Diagonally_Only_When_Dashing,
# Auto_Avoid_Events_Diagonally, Auto_Avoid_Events_Walking_Around, Auto_Avoid_Try_Jumping_First, Auto_Avoid_Events_Max_Offset
#
# v1.1: Added Auto_Avoid_Retain_Direction and Auto_Avoid_Only_When_Dashing configurations
#

module OrangeMovement
  #------------------------------------------------------------
  #------------------------------------------------------------
  #---------------------  CONFIGURATION  ----------------------
  #------------------------------------------------------------
  #------------------------------------------------------------

  #Tile_Sections - The number of pieces to break the tile into. Must be one of the following values:
  # 1 - Doesn't change anything
  # 2 - Will move 16px at each step
  # 4 - Will move 8px at each step - RECOMMENDED
  # 8 - Will move 4px at each step - ALSO GOOD
  # 16 - Will move 2px at each step
  # 32 - Will move 1px at each step
  # Other values between 1 and 32 may or may not work.

  Tile_Sections = 4

  #Set this to false if you don't want the player to walk diagonally
  Enable_Diagonal_Movement = true

  #Auto Avoid: If enabled, the player will automatically walk around small obstacles.
  Auto_Avoid = true

  #If this is set to false, the script won't try to avoid an obstacle by walking diagonally
  Auto_Avoid_Diagonally = true
  #If this is set to false, the script won't try to avoid an obstacle by walking in a different direction
  Auto_Avoid_Walking_Around = true

  #How many tiles the player can walk on a different direction to automatically avoid a blocked tile
  #Values smaller than the step size won't have any effect
  #Set to false to disable it
  Auto_Avoid_Max_Offset = 0.75

  #If true, the player won't turn when walking on another direction for the auto_avoid by offset effect
  Auto_Avoid_Retain_Direction = true

  #If this is set to true, the auto avoid diagonally will only be available when the player is dashing
  Auto_Avoid_Diagonally_Only_When_Dashing = false
  
  #If this is set to true, the auto avoid by offset will only be available when the player is dashing
  Auto_Avoid_Offset_Only_When_Dashing = false

  #Should the player also avoid events?
  Auto_Avoid_Events_Diagonally = true
  Auto_Avoid_Events_Walking_Around = true
  Auto_Avoid_Events_Max_Offset = 0.35

  #If this is set to true, the script will try to jump before trying to avoid an obstacle by walking diagonally
  Auto_Avoid_Try_Jumping_First = false

  #Auto Jump: If enabled, the player will automatically jump over small obstacles
  # If set to false, the feature won't even be loaded on rpg maker, to avoid possible script conflicts.
  # If set to true, the feature will always be available
  # If set to an integer value, the script will look for a switch with that ID to decide if the feature is enabled or not
  Auto_Jump = true

  #Auto_Jump_Only_When_Dashing
  #If this is set to true, the auto jump will only be available when the player is dashing
  Auto_Jump_Only_When_Dashing = true

  #Disables auto jump when the party is bigger than 1
  Auto_Jump_Only_When_Alone = true

  #Sound effect to play when the player jumps
  #You can add more than one SE options by using an array 
  #Set to false to disable

  Auto_Jump_Sound_Effect = false
  #Auto_Jump_Sound_Effect = 'Jump1'
  #Auto_Jump_Sound_Effect = ['Jump1', 'Jump2']
  
  #The volume of the jump sound effect 
  Auto_Jump_Sound_Effect_Volume = 80

  #The pitch value of the jump sound effect
  #You can set it to a range of values to create a small variation on the sound
  Auto_Jump_Sound_Effect_Pitch = 80..100
 
  #The region of the jumpable obstacles
  #Set to true to jump over anything
  #Set to false to disable jumping over tiles
  Auto_Jump_Region_Id = false
  
  #Auto_Jump_Region_Always_Passable
  #Set to an integer value to treat all tiles configured with that region as passable when jumping
  #Set to false to disable
  #Set to true to set everything as passable
  Auto_Jump_Region_Always_Passable = false

  #Auto_Jump_Region_Never_Passable
  #Set to an integer value to treat all tiles configured with that region as non passable when jumping
  #Set to false to disable
  #Set to true to set everything as non passable
  Auto_Jump_Region_Never_Passable = false
  
  #The delay between jumps
  Auto_Jump_Delay = 12
  
  #Should the player jump over events too?
  # Set true to enable jumping over all events
  # Set false to disable jumping over all events
  # --not-implemented-yet--> Set it to a string value to create a filter on which events to jump (the script will look for the same string on the event's title)
  Auto_Jump_Over_Events = true

  #Auto_Jump_Fall_Enabled
  #This let's you configure areas from where the player can fall, using regions.
  Auto_Jump_Fall_Enabled = true
  Auto_Jump_Fall_Down_Region = 2
  Auto_Jump_Fall_Left_Region = 4
  Auto_Jump_Fall_Right_Region = 6
  Auto_Jump_Fall_Up_Region = 8

  #If this is set to false, the script won't be loaded by rpg maker
  #If it's set to an integer value, the script will look for an switch with that ID to determine if the script should be active or not
  Enabled = true

  Enable_Hitbox = false

  Player_Hitbox_X_Offset = 0
  Player_Hitbox_Y_Offset = 0
  Player_Hitbox_Width = 32
  Player_Hitbox_Height = 32

  # Set this to true to trigger all available events everytime. For example: If the player steps on two different events with "on touch" trigger, both will be triggered if this is true
  # If this is false, only one of them will be triggered
  Trigger_All_Events = false

  # If set to true, an event will only be triggered for a second time if you leave the tile it is on and step on the tile again. If you just move into the tile, it won't be triggered.
  # If set to false, the event will be triggered again after each step
  # Setting this to true may break compatibility with other scripts (it's not compatible with Effectus, for example)
  # Check the additional scripts here for compatibility fixes: https://github.com/Hudell/scripts/tree/master/standalone/movement/compatibility
  Block_Repeated_Event_Triggering = true

  #------------------------------------------------------------
  #------------------------------------------------------------
  #---------------  DON'T EDIT AFTER THIS LINE  ---------------
  #------------------------------------------------------------
  #------------------------------------------------------------

  Step_Size = 1.0 / Tile_Sections
  if Enable_Hitbox
    Hitbox_X_Size = Player_Hitbox_X_Offset / 32.0
    Hitbox_Y_Size = Player_Hitbox_Y_Offset / 32.0
    Hitbox_H_Size = Player_Hitbox_Width / 32.0
    Hitbox_V_Size = Player_Hitbox_Height / 32.0
  else
    Hitbox_X_Size = 0
    Hitbox_Y_Size = 0
    Hitbox_H_Size = 1
    Hitbox_V_Size = 1
  end

  def direction_goes_left?(direction)
    return [1, 4, 7].include?(direction)
  end
  def direction_goes_right?(direction)
    return [3, 6, 9].include?(direction)
  end
  def direction_goes_up?(direction)
    return [*7..9].include?(direction)
  end
  def direction_goes_down?(direction)
    return [*1..3].include?(direction)
  end

  def enabled?
    return true if Enabled == true
    return false if Enabled == false
    return $game_switches[Enabled] if Enabled.is_a?(Fixnum)
    return false
  end
end

module Direction
  def self.up; 8; end
  def self.down; 2; end
  def self.left; 4; end
  def self.right; 6; end
  def self.up_left; 7; end
  def self.up_right; 9; end
  def self.down_left; 1; end
  def self.down_right; 3; end
end

unless OrangeMovement::Enabled == false
  class Game_Map
    include OrangeMovement

    def x_with_direction(x, d)
      if direction_goes_left?(d)
        return x - 1
      elsif direction_goes_right?(d)
        return x + 1
      else
        return x
      end
    end

    def y_with_direction(y, d)
      if direction_goes_down?(d)
        return y + 1
      elsif direction_goes_up?(d)
        return y - 1
      else
        return y
      end
    end

    def round_x_with_direction(x, d)
      round_x(x_with_direction(x, d))
    end

    def round_y_with_direction(y, d)
      round_y(y_with_direction(y, d))
    end

    def player_x_with_direction(x, d)
      if enabled?
        step_size = Step_Size
        if $game_player.move_route_forcing
          step_size = 1
        end

        if direction_goes_left?(d)
          return x - step_size
        elsif direction_goes_right?(d)
          return x + step_size
        else
          return x
        end
      else
        return x_with_direction(x, d)
      end
    end

    def player_y_with_direction(y, d)
      if enabled?
        step_size = Step_Size
        if $game_player.move_route_forcing
          step_size = 1
        end

        if direction_goes_down?(d)
          return y + step_size
        elsif direction_goes_up?(d)
          return y - step_size
        else
          return y
        end
      else
        return y_with_direction(y, d)
      end
    end

    def round_player_x_with_direction(x, d)
      round_x(player_x_with_direction(x, d))
    end

    def round_player_y_with_direction(y, d)
      round_y(player_y_with_direction(y, d))
    end
  end

  module Orange_Character
    include OrangeMovement
    def tile_x
      diff = @x - @x.floor
      if diff < 5
        return @x.floor
      else
        return @x.ceil
      end
    end

    def tile_y
      diff = @y - @y.floor
      if diff < 5
        return @y.floor
      else
        return @y.ceil
      end
    end

    def float_x
      @x
    end

    def float_y
      @y
    end

    def front_x
      if direction_goes_left?(direction)
        return @x.floor - 1
      elsif direction_goes_right?(direction)
        return @x.ceil + 1
      else
        x_diff = @x - @x.floor
        if x_diff < 0.5
          return @x.floor
        else
          return @x.ceil
        end
      end
    end

    def front_y
      if direction_goes_up?(direction)
        return @y.floor - 1
      elsif direction_goes_down?(direction)
        return @y.ceil + 1
      else
        y_diff = @y - @y.floor
        if y_diff < 0.5
          return @y.floor
        else
          return @y.ceil
        end
      end
    end

    def x
      tile_x
    end

    def y
      tile_y
    end

    def pos?(x, y)
      if @x.floor == x || @x.ceil == x
        return true if @y.floor == y || @y.ceil == y
      end

      false
    end    

    def tileset_passable?(x, y, d)
      x2 = $game_map.round_player_x_with_direction(x, d)
      y2 = $game_map.round_player_y_with_direction(y, d)
      return false unless $game_map.valid?(x2, y2)

      return true if @through || debug_through?
      return false unless map_passable?(x, y, d)
      return false unless map_passable?(x2, y2, reverse_dir(d))

      return true
    end

    def passable?(x, y, d)
      return false unless tileset_passable?(x, y, d)
      return true if @through || debug_through?

      x2 = $game_map.round_player_x_with_direction(x, d)
      y2 = $game_map.round_player_y_with_direction(y, d)

      return false if collide_with_characters?(x2, y2)
      return true
    end

    def run_for_all_positions(x, y, &block)
      if Enable_Hitbox
        first_x = (x + Hitbox_X_Size).floor
        last_x = (x + Hitbox_X_Size + Hitbox_H_Size - 0.01).floor
        first_y = (y + Hitbox_Y_Size).floor
        last_y = (y + Hitbox_Y_Size + Hitbox_V_Size - 0.01).floor

        for new_x in first_x..last_x
          for new_y in first_y..last_y
            result = block.call(new_x, new_y)
              
            return true if result == true
          end
        end

        return false
      else
        return true if block.call(x.floor, y.floor) == true

        if x != x.floor
          return true if block.call(x.ceil, y.floor) == true

          if y != y.floor
            return true if block.call(x.ceil, y.ceil) == true
          end
        end

        if y != y.floor
          return true if block.call(x.floor, y.ceil) == true
        end

        return false
      end
    end    

    def collide_with_events?(x, y)
      run_for_all_positions(x, y) do |block_x, block_y|
        super(block_x, block_y)
      end
    end

    def collide_with_vehicles?(x, y)
      run_for_all_positions(x, y) do |block_x, block_y|
        super(block_x, block_y)
      end
    end  

    def can_go_up?(x, y, recursive = true)
      if Enable_Hitbox
        the_x = x + Hitbox_X_Size
        the_y = y + Hitbox_Y_Size

        end_x = the_x + Hitbox_H_Size - 0.01
        destination_y = the_y - Step_Size

        if the_y.floor != destination_y.floor
          for new_x in the_x.floor..end_x.floor
            return false unless $game_map.passable?(new_x, the_y.floor, Direction.up)
            return false unless $game_map.passable?(new_x, destination_y.floor, Direction.down)
          end
        else
          for new_x in the_x.floor..end_x.floor
            return false unless $game_map.passable?(new_x, the_y.floor, Direction.up) || $game_map.passable?(new_x, the_y.floor, Direction.down)
          end
        end
      else
        y_diff = y.floor - y

        if y_diff < Step_Size
          return false unless $game_map.passable?(x.floor, y.floor, Direction.up)
        end        

        if recursive
          if x > x.floor
            return false unless can_go_right?(x, y, false)
          end
        end
      end

      return true
    end

    def can_go_left?(x, y, recursive = true)
      if Enable_Hitbox
        the_x = x + Hitbox_X_Size
        the_y = y + Hitbox_Y_Size

        end_y = the_y + Hitbox_V_Size - 0.01
        destination_x = the_x - Step_Size

        if the_x.floor != destination_x.floor
          for new_y in the_y.floor..end_y.floor
            return false unless $game_map.passable?(the_x.floor, new_y, Direction.left)
            return false unless $game_map.passable?(destination_x.floor, new_y, Direction.right)
          end
        else
          for new_y in the_y.floor..end_y.floor
            return false unless $game_map.passable?(the_x.floor, new_y, Direction.left) || $game_map.passable?(the_x.floor, new_y, Direction.right)
          end          
        end
      else
        x_diff = x.floor - x

        if x_diff < Step_Size
          return false unless $game_map.passable?(x.floor, y.floor, Direction.left)
        end
  
        if recursive
          if y > y.floor
            return false unless can_go_down?(x, y, false)
          end
        end
      end

      
      return true
    end

    def can_go_down?(x, y, recursive = true)
      if Enable_Hitbox
        the_x = x + Hitbox_X_Size
        the_y = y + Hitbox_Y_Size

        end_x = the_x + Hitbox_H_Size - 0.01
        end_y = the_y + Hitbox_V_Size - 0.01
        destination_y = the_y + Step_Size
        destination_end_y = end_y + Step_Size

        if end_y.floor != destination_end_y.floor
          for new_x in the_x.floor..end_x.floor
            return false unless $game_map.passable?(new_x, end_y.floor, Direction.down)
            return false unless $game_map.passable?(new_x, destination_end_y.floor, Direction.up)
          end
        end
      else
        return false unless $game_map.passable?(x.floor, y.floor, Direction.down)
        return false unless $game_map.passable?(x.floor, y.floor + 1, Direction.up)

        if x > x.floor
          return false unless $game_map.passable?(x.floor + 1, y.floor, Direction.down)
          #I'm not sure if "y.floor + 1" is right, shouldn't it be y.ceil and only if that's different from y.floor?
          return false unless $game_map.passable?(x.floor + 1, y.floor + 1, Direction.up)
        end

        if y > y.floor && y + Step_Size >= y.ceil
          return false unless $game_map.passable?(x.ceil, y.ceil, Direction.down)
        end
  
        if recursive
          if x > x.floor
            return false unless can_go_right?(x, y, false)
          end
        end
      end

      true
    end

    def can_go_right?(x, y, recursive = true)
      if Enable_Hitbox
        the_x = x + Hitbox_X_Size
        the_y = y + Hitbox_Y_Size

        end_x = the_x + Hitbox_H_Size - 0.01
        end_y = the_y + Hitbox_V_Size - 0.01
        destination_x = the_x + Step_Size
        destination_end_x = end_x + Step_Size

        if end_x.floor != destination_end_x.floor
          for new_y in the_y.floor..end_y.floor
            return false unless $game_map.passable?(end_x.floor, new_y, Direction.right)
            return false unless $game_map.passable?(destination_end_x.floor, new_y, Direction.left)
          end
        end
      else
        return false unless $game_map.passable?(x.floor, y.floor, Direction.right)
        return false unless $game_map.passable?(x.floor + 1, y.floor, Direction.left)

        if x > x.floor && x + Step_Size >= x.ceil
          return false unless $game_map.passable?(x.ceil, y.floor, Direction.right)
        end

        if y > y.floor
          return false unless $game_map.passable?(x.floor, y.ceil, Direction.right)
          #I'm not sure if "x.floor + 1" is right, shouldn't it be x.ceil and only if that's different from x.floor?
          return false unless $game_map.passable?(x.floor + 1, y.ceil, Direction.left)

          if y + Step_Size >= y.ceil
            return false unless $game_map.passable?(x.floor, y.floor, Direction.right)
          end
        end        
  
        if recursive
          if y > y.floor
            return false unless can_go_down?(x, y, false)
          end
        end
      end

      true
    end

    def module_map_passable?(x, y, d)
      if direction_goes_up?(d)
        return false unless can_go_up?(x, y)
      elsif direction_goes_down?(d)
        return false unless can_go_down?(x, y)
      end

      if direction_goes_left?(d)
        return false unless can_go_left?(x, y)
      elsif direction_goes_right?(d)
        return false unless can_go_right?(x, y)
      end

      return true
    end

    def diagonal_passable?(x, y, horz, vert)
      x2 = $game_map.round_player_x_with_direction(x, horz)
      y2 = $game_map.round_player_y_with_direction(y, vert)

      if passable?(x, y, vert) && passable?(x, y2, horz)
        return true
      end

      if passable?(x, y, horz) && passable?(x2, y, vert)
        return true
      end

      return false
    end

    def module_move_straight(d, turn_ok = true)
      @move_succeed = passable?(@x, @y, d)
      if @move_succeed
        set_direction(d)
        
        @x = $game_map.round_player_x_with_direction(@x, d)
        @y = $game_map.round_player_y_with_direction(@y, d)
        @real_x = $game_map.player_x_with_direction(@x, reverse_dir(d))
        @real_y = $game_map.player_y_with_direction(@y, reverse_dir(d))

        increase_steps
      elsif turn_ok
        set_direction(d)
        check_event_trigger_touch_front
      end
    end    

    def module_move_diagonal(horz, vert)
      @move_succeed = diagonal_passable?(@x, @y, horz, vert)
      if @move_succeed
        @x = $game_map.round_player_x_with_direction(@x, horz)
        @y = $game_map.round_player_y_with_direction(@y, vert)
        @real_x = $game_map.player_x_with_direction(@x, reverse_dir(horz))
        @real_y = $game_map.player_y_with_direction(@y, reverse_dir(vert))
        increase_steps
      end
      set_direction(horz) if @direction == reverse_dir(horz)
      set_direction(vert) if @direction == reverse_dir(vert)
    end
  end

  class Game_Follower < Game_Character
    include OrangeMovement
    include Orange_Character

    alias :hudell_orange_movement_game_follower_map_passable? :map_passable?
    def map_passable?(x, y, d)
      return hudell_orange_movement_game_follower_map_passable?(x, y, d) unless enabled?

      return module_map_passable?(x, y, d)
    end

    alias :orange_movement_game_follower_move_straight :move_straight
    def move_straight(d, turn_ok = true)
      return orange_movement_game_follower_move_straight(d, turn_ok) unless enabled?
      
      module_move_straight(d, turn_ok)
    end

    alias :orange_movement_game_follower_move_diagonal :move_diagonal
    def move_diagonal(horz, vert)
      return orange_movement_game_follower_move_diagonal(horz, vert) unless enabled?
      module_move_diagonal(horz, vert)
    end

    alias :orange_movement_game_follower_chase_preceding_character :chase_preceding_character
    def chase_preceding_character
      return orange_movement_game_follower_chase_preceding_character unless enabled?

      unless moving?
        ideal_x = @preceding_character.float_x
        ideal_y = @preceding_character.float_y

        case @preceding_character.direction
        when 2
          ideal_y -= 1
        when 4
          ideal_x += 1
        when 6
          ideal_x -= 1
        when 8
          ideal_y += 1
        end

        sx = distance_x_from(ideal_x)
        sy = distance_y_from(ideal_y)
        if sx.abs >= Step_Size && sy.abs >= Step_Size
          move_diagonal(sx > 0 ? 4 : 6, sy > 0 ? 8 : 2)
        elsif sx.abs >= Step_Size
          move_straight(sx > 0 ? 4 : 6)
        elsif sy.abs >= Step_Size
          move_straight(sy > 0 ? 8 : 2)
        end
      end
    end
  end

  class Game_Player < Game_Character
    include OrangeMovement
    include Orange_Character

    alias :hudell_orange_movement_game_player_map_passable? :map_passable?
    def map_passable?(x, y, d)
      return hudell_orange_movement_game_player_map_passable?(x, y, d) unless enabled?

      return module_map_passable?(x, y, d)
    end

    alias :orange_movement_game_player_move_straight :move_straight
    def move_straight(d, turn_ok = true)
      return orange_movement_game_player_move_straight(d, turn_ok) unless enabled?
      
      module_move_straight(d, turn_ok)
      @followers.move if @move_succeed
    end

    alias :orange_movement_game_player_move_diagonal :move_diagonal
    def move_diagonal(horz, vert)
      return orange_movement_game_player_move_diagonal(horz, vert) unless enabled?
      module_move_diagonal(horz, vert)

      @followers.move if @move_succeed
    end

    alias :orange_movement_game_player_start_map_event :start_map_event
    def start_map_event(x, y, triggers, normal)
      return orange_movement_game_player_start_map_event(x, y, triggers, normal) unless enabled?
      return if $game_map.interpreter.running?

      run_for_all_positions(x, y) do |block_x, block_y|
        unless Trigger_All_Events
          return if $game_map.any_event_starting?
        end

        if Block_Repeated_Event_Triggering == true
          do_actual_start_map_event(block_x, block_y, triggers, normal)
        else
          orange_movement_game_player_start_map_event(block_x, block_y, triggers, normal)
        end
      end
    end

    def do_actual_start_map_event(block_x, block_y, triggers, normal)
      return if is_tile_checked?(block_x, block_y)

      $game_map.events_xy(block_x, block_y).each do |event|
        if event.trigger_in?(triggers) && event.normal_priority? == normal
          mark_tile_as_checked(event.x, event.y) if event.trigger == 1 || event.trigger == 2
          event.start
        end
      end
    end

    def is_tile_checked?(block_x, block_y)
      return false if @checked_tiles.nil?

      @checked_tiles.each do |tile|
        next if tile[:x] != block_x
        next if tile[:y] != block_y

        return true
      end

      return false
    end

    def mark_tile_as_checked(x, y)
      @checked_tiles = [] if @checked_tiles.nil?
      @checked_tiles << {:x => x, :y => y}
    end

    def clear_checked_tiles
      return if @checked_tiles.nil?
      new_list = []

      @checked_tiles.each do |tile|
        next if tile[:x] != $game_player.float_x.floor && tile[:x] != $game_player.float_x.ceil
        next if tile[:y] != $game_player.float_y.floor && tile[:y] != $game_player.float_y.ceil

        new_list << tile
      end

      @checked_tiles = new_list
    end

    unless OrangeMovement::Auto_Jump == false && OrangeMovement::Auto_Avoid == false
      alias :orange_movement_game_player_move_by_input :move_by_input
      def move_by_input
        return orange_movement_game_player_move_by_input unless enabled?
        return if !movable? || $game_map.interpreter.running?

        button = :DOWN
        
        d = Input.dir4
        case d
          when 2; button = :DOWN
          when 4; button = :LEFT
          when 6; button = :RIGHT
          when 8; button = :UP
        end

        clear_checked_tiles

        if passable?(@x, @y, d)
          unless OrangeMovement::Enable_Diagonal_Movement == false
            d = Input.dir8
          end

          do_movement(d)
        else
          tileset_passable = tileset_passable?(@x, @y, d)
          should_try_jumping = true
          max_offset = Auto_Avoid_Max_Offset
          should_try_avoiding_diagonally = Auto_Avoid == true
          should_try_avoiding_walking_around = Auto_Avoid == true && Auto_Avoid_Max_Offset != false

          if tileset_passable
            x2 = $game_map.round_player_x_with_direction(x, d)
            y2 = $game_map.round_player_y_with_direction(y, d)

            if collide_with_characters?(x2, y2)
              if should_try_avoiding_diagonally
                should_try_avoiding_diagonally = Auto_Avoid_Events_Diagonally
              end
              if should_try_avoiding_walking_around
                should_try_avoiding_walking_around = Auto_Avoid_Events_Walking_Around
                max_offset = Auto_Avoid_Events_Max_Offset
              end
            end
          end

          if Auto_Avoid_Try_Jumping_First == true
            return true if call_jump(d)
            should_try_jumping = false
          end

          if should_try_avoiding_diagonally
            if try_to_avoid(d)
              should_try_jumping = false
              should_try_avoiding_walking_around = false
            end
          end

          if should_try_jumping
            return true if call_jump(d)
          end

          if should_try_avoiding_walking_around
            return true if try_to_avoid_again(d, max_offset)
          end

          if @direction != d
            set_direction(d)
            check_event_trigger_touch_front
          end
        end
      end

      def call_jump(d)
        if Auto_Jump == true || (Auto_Jump.is_a?(Fixnum) && $game_switches[Auto_Jump])
          if !Auto_Jump_Only_When_Dashing || dash?
            if !Auto_Jump_Only_When_Alone || $game_party.members.length == 1
              return true if try_to_jump(d)
            end
          end
        end

        return false
      end

      def do_movement(d)
        @avoid_delay = nil

        case d 
          when 2, 4, 6, 8
            move_straight(d, true)
          when 1
            move_diagonal(4, 2)
          when 3
            move_diagonal(6, 2)
          when 7
            move_diagonal(4, 8)
          when 9
            move_diagonal(6, 8)
        end        
      end      
    end

    unless OrangeMovement::Auto_Avoid == false
      def try_to_avoid(d)
        return false if Auto_Avoid_Diagonally == false

        if Auto_Avoid_Diagonally_Only_When_Dashing == true
          return false unless dash?
        end

        if d == Direction.left || d == Direction.right
          if diagonal_passable?(@x, @y, d, Direction.down)
            do_movement(d - 3)
            return true
          elsif diagonal_passable?(@x, @y, d, Direction.up)
            do_movement(d + 3)
            return true
          end
        elsif d == Direction.up || d == Direction.down
          if diagonal_passable?(@x, @y, Direction.left, d)
            do_movement(d - 1)
            return true
          elsif diagonal_passable?(@x, @y, Direction.right, d)
            do_movement(d + 1)
            return true
          end
        end

        return false
      end

      #If the first try failed, try again considering the offset
      def try_to_avoid_again(d, max_offset)
        return false if Auto_Avoid_Walking_Around == false

        if Auto_Avoid_Offset_Only_When_Dashing == true
          return false unless dash?
        end

        if d == Direction.left || d == Direction.right
          #If the player can't walk diagonally on the current position, but would be able to walk if he were a little higher or lower then move vertically instead
          #on the next iterations it will keep trying to move diagonally again and it will eventually work before the offset is reached

          offset = Step_Size
          while offset <= max_offset
            if diagonal_passable?(@x, @y + offset, d, Direction.down)
              do_movement(Direction.down)
              set_direction(d) if Auto_Avoid_Retain_Direction == true

              return true
            elsif diagonal_passable?(@x, @y - offset, d, Direction.up)
              do_movement(Direction.up)

              set_direction(d) if Auto_Avoid_Retain_Direction == true
              return true
            end

            offset += Step_Size
          end
        elsif d == Direction.up || d == Direction.down
          offset = Step_Size
          while offset <= max_offset
            if diagonal_passable?(@x + offset, @y, Direction.right, d)
              do_movement(Direction.right)
              set_direction(d) if Auto_Avoid_Retain_Direction == true

              return true
            elsif diagonal_passable?(@x - offset, @y, Direction.left, d)
              do_movement(Direction.left)

              set_direction(d) if Auto_Avoid_Retain_Direction == true
              return true
            end

            offset += Step_Size
          end
        end

        return false
      end
    end

    unless OrangeMovement::Auto_Jump == false
      def events_allow_jump?(destination_x, destination_y)
        return true if Auto_Jump_Over_Events == true
        return false if Auto_Jump_Over_Events == false

        #Conditional jumping has not been implemented yet
        return true
      end

      alias :hudell_orange_movement_game_player_update :update
      def update
        hudell_orange_movement_game_player_update
        if enabled?
          @jump_delay = Auto_Jump_Delay if @jump_delay.nil?
          @jump_delay -= 1 unless @jump_delay == 0
        end
      end

      def on_jump
        return if Auto_Jump_Sound_Effect == false

        se = Auto_Jump_Sound_Effect
        if se.is_a? Array
          se = se.sample
        end

        volume = Auto_Jump_Sound_Effect_Volume
        pitch = Auto_Jump_Sound_Effect_Pitch

        if pitch.is_a? Range
          pitch = pitch.to_a
        end

        if pitch.is_a? Array
          pitch = pitch.sample
        end

        RPG::SE.new(se, volume, pitch).play
      end

      def do_jump(jump_x, jump_y, go_through = true)
        old_through = @through

        if go_through
          @through = true
        end

        on_jump
        jump(jump_x, jump_y)

        if go_through
          @through = old_through
        end

        return true
      end

      def try_to_jump(d)
        jump_x = 0
        jump_y = 0

        case d
          when 2
            jump_y = 1
          when 4
            jump_x = -1
          when 6
            jump_x = 1
          when 8
            jump_y = -1
        end

        #origin is the tile where the player is
        #destination is the tile where the player will jump to
        origin_x = float_x
        origin_y = float_y
        destination_x = origin_x + jump_x
        destination_y = origin_y + jump_y
        jumped = false

        if @jump_delay.nil? || @jump_delay == 0
          # jump over events

          if collide_with_characters?(destination_x, destination_y)
            if events_allow_jump?(destination_x, destination_y)
              if can_jump_over_event?(origin_x, origin_y, d)
                jump_x *= 2
                jump_y *= 2

                destination_x = float_x + jump_x
                destination_y = float_y + jump_y

                unless collide_with_characters?(destination_x, destination_y)
                  do_jump(jump_x, jump_y)
                  return true
                end
              end
            end
          end
        end

        unless Auto_Jump_Region_Id == false
          #If it's jumping to the next tile
          if passable_any_direction?(destination_x, destination_y)
            if (Auto_Jump_Region_Id == true) || ($game_map.region_id(origin_x, origin_y) == Auto_Jump_Region_Id) || ($game_map.region_id(destination_x, destination_y) == Auto_Jump_Region_Id)
              jumped = jump_if_clear(jump_x, jump_y, d)
            end
          else
            #this "else" treats the case where the player is jumping over a whole tile, stopping two tiles away from it's original position            
            if collide_with_characters?(destination_x, destination_y)
              return
            end

            #Check if the tile allow's jump
            if (Auto_Jump_Region_Id == true) || ($game_map.region_id(destination_x, destination_y) == Auto_Jump_Region_Id)
              #Updates the destination tile
              jump_x *= 2
              jump_y *= 2

              destination_x = origin_x + jump_x
              destination_y = origin_y + jump_y
              
              if passable_any_direction?(destination_x, destination_y)
                jumped = jump_if_clear(jump_x, jump_y, d)
              end
            end
          end
        end

        return true if jumped
        return false unless Auto_Jump_Fall_Enabled == true

        case d
          #when falling down, it should test the front tile instead, because on this case the "fallable" area is visible on screen
        when Direction.down; return fall_down if position_has_region?(x, y + 1, Auto_Jump_Fall_Down_Region)
        when Direction.left; return fall_left if position_has_region?(float_x, y, Auto_Jump_Fall_Left_Region)
        when Direction.right; return fall_right if position_has_region?(float_x, y, Auto_Jump_Fall_Right_Region)
        when Direction.up; return fall_up if position_has_region?(x, y, Auto_Jump_Fall_Up_Region)
        end

        return false
      end

      def position_has_region?(x, y, region_id)
        return true if $game_map.region_id(x.floor, y.floor) == region_id
        return true if $game_map.region_id(x.floor, y.ceil) == region_id
        return true if $game_map.region_id(x.ceil, y.ceil) == region_id
        return true if $game_map.region_id(x.ceil, y.floor) == region_id
        false
      end

      def fall_down
        fall_x = x
        fall_x2 = x
        jump_y = 1
        fall_y = float_y + jump_y

        if x != float_x
          fall_x = float_x.floor
          fall_x2 = float_x.ceil
        end

        return false unless position_has_region?(fall_x2, fall_y, Auto_Jump_Fall_Down_Region)

        #While the region doesn't change, keep falling
        while position_has_region?(fall_x, fall_y, Auto_Jump_Fall_Down_Region) && position_has_region?(fall_x2, fall_y, Auto_Jump_Fall_Down_Region)

          #If it's an invalid tile, abort falling
          return false if !$game_map.valid?(fall_x, fall_y.floor)
          return false if !$game_map.valid?(fall_x2, fall_y.floor)
          return false if !$game_map.valid?(fall_x, fall_y.ceil)
          return false if !$game_map.valid?(fall_x2, fall_y.ceil)

          jump_y += 1
          fall_y = y + jump_y
        end

        return jump_if_clear(0, jump_y, Direction.down, true)
      end

      def fall_left
        jump_x = -1
        fall_x = float_x + jump_x
        fall_y = y
        fall_y2 = y

        if y != float_y
          fall_y = float_y.floor
          fall_y2 = float_y.ceil
        end

        return false unless $game_map.region_id(x, fall_y2) == Auto_Jump_Fall_Left_Region

        #While the region doesn't change, keep falling
        while position_has_region?(fall_x, fall_y, Auto_Jump_Fall_Left_Region) && position_has_region?(fall_x, fall_y2, Auto_Jump_Fall_Left_Region)
          #If it's an invalid tile, abort falling
          return false if !$game_map.valid?(fall_x.floor, fall_y)
          return false if !$game_map.valid?(fall_x.floor, fall_y2)
          return false if !$game_map.valid?(fall_x.ceil, fall_y)
          return false if !$game_map.valid?(fall_x.ceil, fall_y2)

          jump_x -= 1
          fall_x = x + jump_x
        end

        return jump_if_clear(jump_x, 0, Direction.left, true)        
      end

      def fall_right
        jump_x = 1
        fall_x = float_x + jump_x
        fall_y = y
        fall_y2 = y

        if y != float_y
          fall_y = float_y.floor
          fall_y2 = float_y.ceil
        end

        return false unless position_has_region?(float_x, fall_y2, Auto_Jump_Fall_Right_Region)

        #While the region doesn't change, keep falling
        while position_has_region?(fall_x, fall_y, Auto_Jump_Fall_Right_Region) && position_has_region?(fall_x, fall_y2, Auto_Jump_Fall_Right_Region)
          #If it's an invalid tile, abort falling
          return false if !$game_map.valid?(fall_x.floor, fall_y)
          return false if !$game_map.valid?(fall_x.floor, fall_y2)
          return false if !$game_map.valid?(fall_x.ceil, fall_y)
          return false if !$game_map.valid?(fall_x.ceil, fall_y2)

          jump_x += 1
          fall_x = x + jump_x
        end

        return jump_if_clear(jump_x, 0, Direction.right, true)        
      end

      def fall_up
        fall_x = x
        fall_x2 = x
        jump_y = -1
        fall_y = float_y + jump_y

        if x != float_x
          fall_x = float_x.floor
          fall_x2 = float_x.ceil
        end

        return false unless position_has_region?(fall_x2, float_y, Auto_Jump_Fall_Up_Region)

        #While the region doesn't change, keep falling
        while position_has_region?(fall_x, fall_y, Auto_Jump_Fall_Up_Region) && position_has_region?(fall_x2, fall_y, Auto_Jump_Fall_Up_Region)
          #If it's an invalid tile, abort falling
          return false if !$game_map.valid?(fall_x, fall_y)
          return false if !$game_map.valid?(fall_x2, fall_y)

          jump_y -= 1
          fall_y = y + jump_y
        end

        return jump_if_clear(0, jump_y, Direction.up, true)
      end

      def jump_if_clear(jump_x, jump_y, d, go_through = true)
        #If there's an event at the destination position, don't jump
        if collide_with_characters?(float_x + jump_x, float_y + jump_y)
          return false
        end

        #If it's jumping to the next tile only, then check for events on the origin tile too
        if (jump_x == 1 or jump_y == 1)
          if collide_with_characters?(float_x, float_y)
            return false
          end
        end

        return do_jump(jump_x, jump_y, go_through)
      end

      def can_jump_over_event?(x, y, d)
        x2 = $game_map.round_x_with_direction(x, d)
        y2 = $game_map.round_y_with_direction(y, d)

        x3 = $game_map.round_x_with_direction(x2, d)
        y3 = $game_map.round_y_with_direction(y2, d)

        return false unless $game_map.valid?(x2, y2)
        return false unless $game_map.valid?(x3, y3)

        return true if @through || debug_through?
        return false unless map_passable?(x, y, d)
        return false unless map_passable?(x2, y2, reverse_dir(d))
        return false unless map_passable?(x2, y2, d)
        return false unless map_passable?(x3, y3, reverse_dir(d))
        # return false if collide_with_characters?(x2, y2)
        return true   
      end

      def passable_any_direction?(x, y)
        return false if Auto_Jump_Region_Never_Passable == true
        unless Auto_Jump_Region_Never_Passable == false
          return false if $game_map.region_id(x, y) == Auto_Jump_Region_Never_Passable
        end

        return true if passable?(x, y, 2)
        return true if passable?(x, y, 4)
        return true if passable?(x, y, 6)
        return true if passable?(x, y, 8)
        
        return true if Auto_Jump_Region_Always_Passable == true
        unless Auto_Jump_Region_Always_Passable == false
          return true if $game_map.region_id(x, y) == Auto_Jump_Region_Always_Passable
        end

        return false
      end
    end
  end
end

if OrangeMovement::Block_Repeated_Event_Triggering == true
  class Game_Interpreter
    alias :hudell_orange_movement_game_interpreter_command_201 :command_201
    def command_201
      hudell_orange_movement_game_interpreter_command_201
      return if $game_party.in_battle

      $game_player.clear_checked_tiles
      $game_player.mark_tile_as_checked($game_player.x, $game_player.y)
    end
  end
end
