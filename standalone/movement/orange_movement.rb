#------------------------------------------------------------
#------------------------------------------------------------
#-----------------  ORANGE MOVEMENT SYSTEM  -----------------
#------------------------------------------------------------
#------------------------------------------------------------
#
# Script created by Hudell (www.hudell.com)
# Version: 3.6.1
# You're free to use this script on any project
#
# Change Log:
#
# v3.6: 2016-03-26
# => Fixed movement on looped maps
#
# v3.5: 2015-10-27
# => Fixed a problem where the player sprite wouldn't change back to "walking" before entering a battle.
#
# v3.4: 2015-09-13
# => Added Auto_Avoid_Ignore_Delay_When_Dashing setting
#
# v3.3: 2015-09-08
# => Added Auto_Avoid_Diagonally_Delay and Auto_Avoid_Offset_Delay settings
#
# v3.2: 2015-08-21
# => Improvements on diagonal movement
#
# v3.1: 2015-08-08
# => Added "Dashing_Sprites_Reset_On_Teleport" setting
#
# v3.0: 2015-07-28
# => Added Hitboxes for Events
#
# v2.9: 2015-07-26
# => Fixed a problem where touch events wouldn't trigger when dashing if Tile_Sections was set to 8
#
# v2.8: 2015-07-25
# => Changed support for dashing sprites
#
# v2.7: 2015-07-07
# => Fixed a problem where fixed routes could move the player into blocked tiles
#
# v2.6: 2015-07-05
# => Added functionality to use a different sprite for dashing actors
#
# v2.5: 2015-06-29
# => Support for different step sizes
# => Support for a different hitbox for each actor
#
# v2.4: 2015-06-11
# => Added a new option to ignore empty events when choosing which event to trigger
# => If somehow the player is on the same tile as an unpassable event, they will now be able to leave that tile
# => Fixed a small problem where events would turn to the wrong direction when activated
#
# v2.3: 2015-06-04
# => Added settings to configure passable and unpassable tiles using regions
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
  #---------------------  COMPATIBILITY  ----------------------
  #------------------------------------------------------------
  #------------------------------------------------------------
  #
  # Don't forget to check the compatibility patches and notes at:
  # https://github.com/Hudell/scripts/tree/master/standalone/movement/compatibility
  #
  #
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
  # Other values between 1 and 32 may or may not work.

  Tile_Sections = 4

  #If this is set to false, fixed move routes won't use pixel movement, moving a whole tile instead 
  Fixed_Move_Route_Use_Pixel_Movement = false

  #There are two cases this setting can affect:
  # If pixel movement is disabled (either completely disabled or disabled on fixed move routes), when this setting is true, the script will make sure the player is always aligned to the grid.
  Align_To_Grid = true

  #Set this to false if you don't want the player to walk diagonally
  Enable_Diagonal_Movement = true

  #Auto Avoid: If enabled, the player will automatically walk around small obstacles.
  Auto_Avoid = true

  #If this is set to false, the script won't try to avoid an obstacle by walking diagonally
  Auto_Avoid_Diagonally = true
  #If this is set to false, the script won't try to avoid an obstacle by walking in a different direction
  Auto_Avoid_Walking_Around = true

  #How many frames to wait before executing the auto-avoid diagonally
  Auto_Avoid_Diagonally_Delay = 0
  #How many frames to wait before executing the auto-avoid by offset
  Auto_Avoid_Offset_Delay = 0

  #If true, the delay will not be applied when the player is dashing
  Auto_Avoid_Ignore_Delay_When_Dashing = true

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
  Auto_Avoid_Events_Diagonally_Only_When_Dashing = true
  Auto_Avoid_Events_Walking_Around = true
  Auto_Avoid_Events_Walking_Around_Only_When_Dashing = true
  Auto_Avoid_Events_Max_Offset = 0.35

  #If this is set to true, the script will try to jump before trying to avoid an obstacle by walking diagonally
  Auto_Avoid_Try_Jumping_First = false

  #Auto Jump: If enabled, the player will automatically jump over small obstacles
  # If set to false, the feature won't even be loaded on rpg maker, to avoid possible script conflicts.
  # If set to true, the feature will always be available
  # If set to an integer value, the script will look for a switch with that ID to decide if the feature is enabled or not
  Auto_Jump = 0

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

  #If this is true, the new collision system will be used, you shouldn't use the old one anymore (it may not me compatible with all new features)
  Enable_Hitbox = true

  #The default hitbox configuration for the player, will only be used when there's no hitbox configuration on the actor database

  #Player_Hitbox_X_Offset - move the left position of the hitbox in pixels - Can be configured on the actor database adding this line on the notes: hitbox_x=0
  Player_Hitbox_X_Offset = 0
  #Player_Hitbox_Y_Offset - move the top position of the hitbox in pixels - Can be configured on the actor database adding this line on the notes: hitbox_y=0
  Player_Hitbox_Y_Offset = 0
  #Player_Hitbox_Width - width of the hitbox in pixels - Can be configured on the actor database adding this line on the notes: hitbox_w=0
  Player_Hitbox_Width = 32
  #Player_Hitbox_Height - height of the hitbox in pixels - Can be configured on the actor database adding this line on the notes: hitbox_h=0
  Player_Hitbox_Height = 32

  #If those are set to an integer value, all tiles configured with that region will be always or never passable
  Map_Always_Passable_Region = false
  Map_Never_Passable_Region = false

  # Set this to true to trigger all available events everytime. For example: If the player steps on two different events with "on touch" trigger, both will be triggered if this is true
  # If this is false, only one of them will be triggered
  Trigger_All_Events = false

  #If this is set to true (and Trigger_All_Events is false), when the player is teleported, the events of the tile the player is teleported to will only be triggered if the player leaves it and then touches it again
  Ignore_Teleported_Tile = false

  # If this is true, events without any command won't be triggered 
  Ignore_Empty_Events = true

  # If set to true, an event will only be triggered for a second time if you leave the tile it is on and step on the tile again. If you just move into the tile, it won't be triggered.
  # If set to false, the event will be triggered again after each step
  Block_Repeated_Event_Triggering = true

  # If true, custom event hitboxes will be enabled
  Use_Event_Hitboxes = true

  # If true, the script will automatically change the sprite of the hero based on the settings described below
  Use_Dashing_Sprites = true

  # If true, the script will change the player's sprite to the regular "walking sprite" when entering a house
  Dashing_Sprites_Reset_On_Teleport = true

  # Add those configuration lines on the notes of the actor database:
  #
  #       dashing_sprite_name = sprite_name
  #       dashing_sprite_index = 0
  #       walking_sprite_name = sprite_name
  #       walking_sprite_index = 0
  #
  # You can also change them at any time with those script calls:
  #
  #       $game_player.actor.dashing_sprite_name = 'sprite_name'
  #       $game_player.actor.dashing_sprite_index = 0
  #       $game_player.actor.walking_sprite_name = 'sprite_name'
  #       $game_player.actor.walking_sprite_index = 0
  #
  #------------------------------------------------------------
  #------------------------------------------------------------
  #---------------  DON'T EDIT AFTER THIS LINE  ---------------
  #------------------------------------------------------------
  #------------------------------------------------------------

  Step_Size = 1.0 / Tile_Sections

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

  def input_direction_enabled?(d)
    true
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

class Game_Actor < Game_Battler
  include OrangeMovement
  
  def hitbox_x
    begin
      @hitbox_x = actor.note.scan(/hitbox\_x_*=_*(\-?[0-9]+)/)[0][0].to_i if @hitbox_x.nil?
    rescue
      @hitbox_x = Player_Hitbox_X_Offset
    end

    @hitbox_x
  end

  def hitbox_y
    begin
      @hitbox_y = actor.note.scan(/hitbox\_y_*=_*(\-?[0-9]+)/)[0][0].to_i if @hitbox_y.nil?
    rescue
      @hitbox_y = Player_Hitbox_Y_Offset
    end

    @hitbox_y
  end

  def hitbox_w
    begin
      @hitbox_w = actor.note.scan(/hitbox\_w_*=_*(\-?[0-9]+)/)[0][0].to_i if @hitbox_w.nil?
    rescue
      @hitbox_w = Player_Hitbox_Width
    end

    @hitbox_w
  end

  def hitbox_h
    begin
      @hitbox_h = actor.note.scan(/hitbox\_h_*=_*(\-?[0-9]+)/)[0][0].to_i if @hitbox_h.nil?
    rescue
      @hitbox_h = Player_Hitbox_Height
    end

    @hitbox_h
  end

  def hitbox_x_size
    hitbox_x / 32.0
  end

  def hitbox_y_size
    hitbox_y / 32.0
  end

  def hitbox_h_size
    hitbox_w / 32.0
  end

  def hitbox_v_size
    hitbox_h / 32.0
  end

  def dashing_sprite_name
    begin
      @dashing_sprite_name = actor.note.scan(/dashing\_sprite\_name_*=_*(.*)$/)[0][0].strip if @dashing_sprite_name.nil?
    rescue
    end

    @dashing_sprite_name
  end

  def dashing_sprite_index
    begin
      @dashing_sprite_index = actor.note.scan(/dashing\_sprite\_index_*=_*(.*)$/)[0][0].to_i if @dashing_sprite_index.nil?
    rescue
    end

    @dashing_sprite_index
  end

  def dashing_sprite_name=(value)
    @dashing_sprite_name = value
  end

  def dashing_sprite_index=(value)
    @dashing_sprite_index = value
  end

  def walking_sprite_name
    begin
      @walking_sprite_name = actor.note.scan(/walking\_sprite\_name_*=_*(.*)$/)[0][0].strip if @walking_sprite_name.nil?
    rescue
    end

    @walking_sprite_name
  end

  def walking_sprite_index
    begin
      @walking_sprite_index = actor.note.scan(/walking\_sprite\_index_*=_*(.*)$/)[0][0].to_i if @walking_sprite_index.nil?
    rescue
    end

    @walking_sprite_index
  end

  def walking_sprite_name=(value)
    @walking_sprite_name = value
  end

  def walking_sprite_index=(value)
    @walking_sprite_index = value
  end
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

    def player_x_with_direction(x, d, step_size = Step_Size)
      if enabled?
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

    def player_y_with_direction(y, d, step_size = Step_Size)
      if enabled?
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

    def round_player_x_with_direction(x, d, step_size = Step_Size)
      round_x(player_x_with_direction(x, d, step_size))
    end

    def round_player_y_with_direction(y, d, step_size = Step_Size)
      round_y(player_y_with_direction(y, d, step_size))
    end

    def loop_passable?(x, y, d)
      while (x < 0) 
        x += width
      end
      while (y < 0)
        y += height
      end

      return passable?(x % width, y % height, d)
    end

    alias :hudell_orange_movement_check_passage :check_passage
    def check_passage(x, y, bit)
      if OrangeMovement::Map_Never_Passable_Region != false || OrangeMovement::Map_Always_Passable_Region != false
        region = $game_map.region_id(x, y)

        if OrangeMovement::Map_Always_Passable_Region != false
          return true if region == OrangeMovement::Map_Always_Passable_Region
        end
        if OrangeMovement::Map_Never_Passable_Region != false
          return false if region == OrangeMovement::Map_Never_Passable_Region
        end
      end
      
      return hudell_orange_movement_check_passage(x, y, bit)
    end
  end

  module Orange_ActorCharacter
    def hitbox_x_size
      if actor.nil?
        0
      else
        actor.hitbox_x_size
      end
    end

    def hitbox_y_size
      if actor.nil?
        0
      else
        actor.hitbox_y_size
      end
    end

    def hitbox_v_size
      if actor.nil?
        1
      else
        actor.hitbox_v_size
      end
    end

    def hitbox_h_size
      if actor.nil?
        1
      else
        actor.hitbox_h_size
      end
    end
  end

  module Orange_Character
    include OrangeMovement
    def tile_x
      diff = @x - @x.floor
      if diff < 0.5
        return @x.floor
      else
        return @x.ceil
      end
    end

    def tile_y
      diff = @y - @y.floor
      if diff < 0.5
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

    def hitbox_y
      @y + hitbox_y_size
    end

    def hitbox_x
      @x + hitbox_x_size
    end

    def hitbox_bottom
      hitbox_y + hitbox_h_size
    end

    def position_data
      the_x = @x + hitbox_x_size
      the_y = @y + hitbox_y_size
      width = hitbox_h_size.to_f - 0.01
      height = hitbox_v_size.to_f - 0.01

      return the_x, the_y, the_x + width, the_y + height
    end

    def is_touching_tile?(tile_x, tile_y)
      the_x, the_y, width, height = position_data

      return false unless tile_x >= the_x.floor && tile_x <= width.floor
      return false unless tile_y >= the_y.floor && tile_y <= height.floor
      return true
    end

    def hitbox_x_size
      0
    end

    def hitbox_y_size
      0
    end

    def hitbox_v_size
      1
    end

    def hitbox_h_size
      1
    end

    def left_x
      hitbox_x
    end

    def right_x
      hitbox_x + hitbox_h_size
    end

    def top_y
      hitbox_y
    end

    def bottom_y
      hitbox_y + hitbox_v_size
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

    def my_step_size
      Step_Size
    end

    def custom_through?
      false
    end

    def tileset_passable?(x, y, d)
      x2 = $game_map.round_player_x_with_direction(x, d, my_step_size)
      y2 = $game_map.round_player_y_with_direction(y, d, my_step_size)
      return false unless $game_map.valid?(x2, y2)

      return true if @through || debug_through? || custom_through?
      return false unless map_passable?(x, y, d)
      return false unless map_passable?(x2, y2, reverse_dir(d))

      return true
    end

    def passable?(x, y, d)
      return false unless tileset_passable?(x, y, d)
      return true if @through || debug_through? || custom_through?

      x2 = $game_map.round_player_x_with_direction(x, d, my_step_size)
      y2 = $game_map.round_player_y_with_direction(y, d, my_step_size)

      return false if collide_with_characters?(x2, y2)
      return true
    end

    def run_for_all_positions(x, y, &block)
      if Enable_Hitbox
        first_x = (x + hitbox_x_size).floor
        last_x = (x + hitbox_x_size + hitbox_h_size - 0.01).floor
        first_y = (y + hitbox_y_size).floor
        last_y = (y + hitbox_y_size + hitbox_v_size - 0.01).floor

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
        $game_map.events_xy_nt(block_x, block_y).any? do |event|
          #If the player is "inside" it, then this event won't be considered,
          #because if it did, the player would be locked on it
          if is_touching_tile?(block_x, block_y)
            false
          else
            event.normal_priority? || self.is_a?(Game_Event)
          end
        end
      end
    end

    def collide_with_vehicles?(x, y)
      run_for_all_positions(x, y) do |block_x, block_y|
        super(block_x, block_y)
      end
    end  

    def can_go_up?(x, y, recursive = true, step_size = Step_Size)
      if Enable_Hitbox
        the_x = x + hitbox_x_size
        the_y = y + hitbox_y_size

        end_x = the_x + hitbox_h_size - 0.01
        destination_y = the_y - step_size

        if the_y.floor != destination_y.floor
          for new_x in the_x.floor..end_x.floor


            return false unless $game_map.loop_passable?(new_x, the_y.floor, Direction.up)
            return false unless $game_map.loop_passable?(new_x, destination_y.floor, Direction.down)
            # return false unless $game_map.loop_passable?(new_x, destination_y.floor, Direction.up)
          end
        else
          for new_x in the_x.floor..end_x.floor
            return false unless $game_map.loop_passable?(new_x, the_y.floor, Direction.up) || $game_map.loop_passable?(new_x, the_y.floor, Direction.down)
          end
        end
      else
        y_diff = y.floor - y

        if y_diff < step_size
          return false unless $game_map.loop_passable?(x.floor, y.floor, Direction.up)
        end        

        if recursive
          if x > x.floor
            return false unless can_go_right?(x, y, false)
          end
        end
      end

      return true
    end

    def can_go_left?(x, y, recursive = true, step_size = Step_Size)
      if Enable_Hitbox
        the_x = x + hitbox_x_size
        the_y = y + hitbox_y_size

        end_y = the_y + hitbox_v_size - 0.01
        destination_x = the_x - step_size

        if the_x.floor != destination_x.floor
          for new_y in the_y.floor..end_y.floor
            return false unless $game_map.loop_passable?(the_x.floor, new_y, Direction.left)
            return false unless $game_map.loop_passable?(destination_x.floor, new_y, Direction.right)
          end
        else
          for new_y in the_y.floor..end_y.floor
            return false unless $game_map.loop_passable?(the_x.floor, new_y, Direction.left) || $game_map.loop_passable?(the_x.floor, new_y, Direction.right)
          end          
        end
      else
        x_diff = x.floor - x

        if x_diff < step_size
          return false unless $game_map.loop_passable?(x.floor, y.floor, Direction.left)
        end
  
        if recursive
          if y > y.floor
            return false unless can_go_down?(x, y, false)
          end
        end
      end

      
      return true
    end

    def can_go_down?(x, y, recursive = true, step_size = Step_Size)
      if Enable_Hitbox
        the_x = x + hitbox_x_size
        the_y = y + hitbox_y_size

        end_x = the_x + hitbox_h_size - 0.01
        end_y = the_y + hitbox_v_size - 0.01
        destination_y = the_y + step_size
        destination_end_y = end_y + step_size

        if end_y.floor != destination_end_y.floor
          for new_x in the_x.floor..end_x.floor
            return false unless $game_map.loop_passable?(new_x, end_y.floor, Direction.down)
            return false unless $game_map.loop_passable?(new_x, destination_end_y.floor, Direction.up)
          end
        end
      else
        return false unless $game_map.loop_passable?(x.floor, y.floor, Direction.down)
        return false unless $game_map.loop_passable?(x.floor, y.floor + 1, Direction.up)

        if x > x.floor
          return false unless $game_map.loop_passable?(x.floor + 1, y.floor, Direction.down)
          #I'm not sure if "y.floor + 1" is right, shouldn't it be y.ceil and only if that's different from y.floor?
          return false unless $game_map.loop_passable?(x.floor + 1, y.floor + 1, Direction.up)
        end

        if y > y.floor && y + step_size >= y.ceil
          return false unless $game_map.loop_passable?(x.ceil, y.ceil, Direction.down)
        end
  
        if recursive
          if x > x.floor
            return false unless can_go_right?(x, y, false)
          end
        end
      end

      true
    end

    def can_go_right?(x, y, recursive = true, step_size = Step_Size)
      if Enable_Hitbox
        the_x = x + hitbox_x_size
        the_y = y + hitbox_y_size

        end_x = the_x + hitbox_h_size - 0.01
        end_y = the_y + hitbox_v_size - 0.01
        destination_x = the_x + step_size
        destination_end_x = end_x + step_size

        if end_x.floor != destination_end_x.floor
          for new_y in the_y.floor..end_y.floor
            return false unless $game_map.loop_passable?(end_x.floor, new_y, Direction.right)
            return false unless $game_map.loop_passable?(destination_end_x.floor, new_y, Direction.left)
          end
        end
      else
        return false unless $game_map.loop_passable?(x.floor, y.floor, Direction.right)
        return false unless $game_map.loop_passable?(x.floor + 1, y.floor, Direction.left)

        if x > x.floor && x + step_size >= x.ceil
          return false unless $game_map.loop_passable?(x.ceil, y.floor, Direction.right)
        end

        if y > y.floor
          return false unless $game_map.loop_passable?(x.floor, y.ceil, Direction.right)
          #I'm not sure if "x.floor + 1" is right, shouldn't it be x.ceil and only if that's different from x.floor?
          return false unless $game_map.loop_passable?(x.floor + 1, y.ceil, Direction.left)

          if y + step_size >= y.ceil
            return false unless $game_map.loop_passable?(x.floor, y.floor, Direction.right)
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
      x2 = $game_map.round_player_x_with_direction(x, horz, my_step_size)
      y2 = $game_map.round_player_y_with_direction(y, vert, my_step_size)

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

        if Align_To_Grid == true
          if (move_route_forcing && Fixed_Move_Route_Use_Pixel_Movement == false) || OrangeMovement::Tile_Sections == 1
            case d
            when Direction.left
              step_size = @x - @x.floor
            when Direction.right
              step_size = @x.ceil - @x
            when Direction.up
              step_size = @y - @y.floor
            when Direction.down
              step_size = @y.ceil - @y
            else
              step_size = 0
            end

            step_size = my_step_size if step_size == 0
          else
            step_size = my_step_size
          end
        else
          step_size = my_step_size
        end
        
        @x = $game_map.round_player_x_with_direction(@x, d, step_size)
        @y = $game_map.round_player_y_with_direction(@y, d, step_size)
        @real_x = $game_map.player_x_with_direction(@x, reverse_dir(d), step_size)
        @real_y = $game_map.player_y_with_direction(@y, reverse_dir(d), step_size)

        increase_steps
      elsif turn_ok
        set_direction(d)
        check_event_trigger_touch_front
      end
    end    

    def module_move_diagonal(horz, vert)
      @move_succeed = diagonal_passable?(@x, @y, horz, vert)
      if @move_succeed
        vert_step_size = my_step_size
        horz_step_size = my_step_size

        if Align_To_Grid == true
          if (move_route_forcing && Fixed_Move_Route_Use_Pixel_Movement == false) || (OrangeMovement::Tile_Sections == 1)
            case horz
            when Direction.left
              horz_step_size = @x - @x.floor
            when Direction.right
              horz_step_size = @x.ceil - @x
            else
              horz_step_size = 0
            end

            case vert
            when Direction.up
              vert_step_size = @y - @y.floor
            when Direction.down
              vert_step_size = @y.ceil - @y
            else
              vert_step_size = 0
            end

            horz_step_size = my_step_size if horz_step_size == 0
            vert_step_size = my_step_size if vert_step_size == 0
          end
        end

        @x = $game_map.round_player_x_with_direction(@x, horz, horz_step_size)
        @y = $game_map.round_player_y_with_direction(@y, vert, vert_step_size)
        @real_x = $game_map.player_x_with_direction(@x, reverse_dir(horz), horz_step_size)
        @real_y = $game_map.player_y_with_direction(@y, reverse_dir(vert), vert_step_size)
        increase_steps
      end
      set_direction(horz) if @direction == reverse_dir(horz)
      set_direction(vert) if @direction == reverse_dir(vert)
    end
  end

  class Game_Follower < Game_Character
    include OrangeMovement
    include Orange_Character
    # include Orange_ActorCharacter

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
    include Orange_ActorCharacter

    def my_step_size
      if move_route_forcing && Fixed_Move_Route_Use_Pixel_Movement == false
        1
      else
        Step_Size
      end
    end

    def region_inside_rect?(left, right, top, down, region_id)
      for x in (left.floor)..(right.floor)
        for y in (top.floor)..(down.floor)
          if region_id.is_a? Array
            region_id.each do |id|
              return true if $game_map.region_id(x, y) == id
            end
          else
            return true if $game_map.region_id(x, y) == region_id
          end
        end
      end

      false
    end

    def feet_touching_region?(region_id)
      min_x, min_y, max_x, max_y = position_data
      #Checks only the max_y
      region_inside_rect?(min_x, max_x, max_y, max_y, region_id)
    end

    def touching_region?(region_id)
      min_x, min_y, max_x, max_y = position_data
      region_inside_rect?(min_x, max_x, min_y, max_y, region_id)
    end

    def update_actor_graphic
      if OrangeMovement::Use_Dashing_Sprites
        @was_moving = false if @was_moving.nil?

        if actor
          #Change actor graphic if they are running or not
          if dash? && (moving? || @was_moving) && SceneManager.scene_is?(Scene_Map)
            new_sprite_name = actor.dashing_sprite_name
            new_sprite_index = actor.dashing_sprite_index
          else
            new_sprite_name = actor.walking_sprite_name
            new_sprite_index = actor.walking_sprite_index
          end

          unless new_sprite_name.nil? || new_sprite_index.nil?
            if new_sprite_name != $game_player.character_name || new_sprite_index != $game_player.character_index
              $game_map.interpreter.change_actor_graphic(actor.id, new_sprite_name, new_sprite_index, actor.face_name, actor.face_index)
            end
          end
        end

        @was_moving = moving?
      end      
    end

    alias :hudell_orange_movement_game_player_update :update
    def update
      @moved_last_frame = false if @moved_last_frame.nil?

      update_actor_graphic

      last_real_x = @real_x
      last_real_y = @real_y
      last_moving = moving?

      hudell_orange_movement_game_player_update

      moved = @real_y != last_real_y || @real_x != last_real_x
      
      #Edge case: the player moved to the destination so fast that the Game_Player class thought he didn't move at all
      #This happens when dashing with Tile_Sections = 8
      if moved && !moving? && !last_moving
        $game_party.on_player_walk
        check_touch_event
      end

      @moved_last_frame = moved
      
      unless Auto_Jump == false
        if enabled?
          @jump_delay = Auto_Jump_Delay if @jump_delay.nil?
          @jump_delay -= 1 unless @jump_delay == 0
        end
      end
    end

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

        #If any of those two settings is enabled, then we have to use the custom "start_map_event"
        if Block_Repeated_Event_Triggering == true || OrangeMovement::Ignore_Empty_Events == true
          do_actual_start_map_event(block_x, block_y, triggers, normal)
        else
          #If they are both disabled, then run the standard "start_map_event" to keep compatibility with scripts that use it
          orange_movement_game_player_start_map_event(block_x, block_y, triggers, normal)
        end
      end
    end

    def event_has_anything_to_run?(event)
      return true unless OrangeMovement::Ignore_Empty_Events == true

      event.list.each do |command|
        next if command.code == 108 || command.code == 408 #comments
        next if command.code == 118 #Label
        next if command.code == 0 #End of list

        return true
      end

      return false
    end

    def do_actual_start_map_event(block_x, block_y, triggers, normal)
      return if is_tile_checked?(block_x, block_y)

      $game_map.events_xy(block_x, block_y).each do |event|
        next if event.erased

        if event.trigger_in?(triggers) && event.normal_priority? == normal && event_has_anything_to_run?(event)
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

        @avoid_diagonally_delay = 0 if @avoid_diagonally_delay.nil?
        @avoid_offset_delay = 0 if @avoid_offset_delay.nil?

        button = :DOWN
        
        d = Input.dir4
        diagonal_d = Input.dir8
        alternative_d = d
        return false unless input_direction_enabled?(d)

        #If the player is trying to move diagonally and the non-diagonal direction is unavailable, try the other non-diagonal direction
        if d != diagonal_d
          case diagonal_d
          when Direction.up_left
            alternative_d = d == Direction.up ? Direction.left : Direction.up
          when Direction.up_right
            alternative_d = d == Direction.up ? Direction.right : Direction.up
          when Direction.down_left
            alternative_d = d == Direction.down ? Direction.left : Direction.down
          when Direction.down_right
            alternative_d = d == Direction.down ? Direction.right : Direction.down
          end
        end

        case d
          when 2; button = :DOWN
          when 4; button = :LEFT
          when 6; button = :RIGHT
          when 8; button = :UP
        end

        clear_checked_tiles

        if passable?(@x, @y, d) || passable?(@x, @y, alternative_d)
          #Restart the delay
          if Auto_Avoid_Ignore_Delay_When_Dashing && dash?
            @avoid_diagonally_delay = 0
            @avoid_offset_delay = 0
          else
            @avoid_diagonally_delay = Auto_Avoid_Diagonally_Delay
            @avoid_offset_delay = Auto_Avoid_Offset_Delay
          end

          #Try the diagonal movement first
          unless OrangeMovement::Enable_Diagonal_Movement == false
            do_movement(diagonal_d)
            return if @move_succeed
          end

          do_movement(d)
          do_movement(alternative_d) unless @move_succeed
        else
          tileset_passable = tileset_passable?(@x, @y, d)
          should_try_jumping = true
          max_offset = Auto_Avoid_Max_Offset
          should_try_avoiding_diagonally = Auto_Avoid == true
          should_try_avoiding_walking_around = Auto_Avoid == true && Auto_Avoid_Max_Offset != false

          if tileset_passable
            x2 = $game_map.round_player_x_with_direction(@x, d, my_step_size)
            y2 = $game_map.round_player_y_with_direction(@y, d, my_step_size)

            if collide_with_characters?(x2, y2)
              if should_try_avoiding_diagonally
                if Auto_Avoid_Events_Diagonally
                  if Auto_Avoid_Events_Diagonally_Only_When_Dashing
                    should_try_avoiding_diagonally = dash?
                  end
                else
                  should_try_avoiding_diagonally = false
                end
              end
              if should_try_avoiding_walking_around
                if Auto_Avoid_Events_Walking_Around
                  if Auto_Avoid_Events_Walking_Around_Only_When_Dashing
                    should_try_avoiding_walking_around = dash?
                  end
                else
                  should_try_avoiding_walking_around = false
                end
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

          @avoid_diagonally_delay -= 1 if @avoid_diagonally_delay > 0
          @avoid_offset_delay -= 1 if @avoid_offset_delay > 0
        end
      end

      def call_jump(d)
        if Auto_Jump == true || (Auto_Jump.is_a?(Fixnum) && Auto_Jump > 0 && $game_switches[Auto_Jump])
          if !Auto_Jump_Only_When_Dashing || dash?
            if !Auto_Jump_Only_When_Alone || $game_party.members.length == 1
              return true if try_to_jump(d)
            end
          end
        end

        return false
      end

      def do_movement(d)
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

        return false if @avoid_diagonally_delay > 0

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

        return false if @avoid_offset_delay > 0

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

        return true if @through || debug_through? || custom_through?
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


class Game_Interpreter
  #Use command 322 to change it, this is done to keep compatibility with effectus
  def change_actor_graphic(actor_id, sprite_name, sprite_index, face_name, face_index)
    @params = [actor_id, sprite_name, sprite_index, face_name, face_index]
    command_322
  end

  if OrangeMovement::Block_Repeated_Event_Triggering == true
    alias :hudell_orange_movement_game_interpreter_command_201 :command_201
    def command_201
      hudell_orange_movement_game_interpreter_command_201
      return if $game_party.in_battle

      $game_player.clear_checked_tiles
      $game_player.mark_tile_as_checked($game_player.x, $game_player.y) if OrangeMovement::Ignore_Teleported_Tile
    end
  end

  if OrangeMovement::Dashing_Sprites_Reset_On_Teleport == true
    alias :hudell_orange_movement_game_interpreter_command_201_B :command_201
    def command_201
      $game_player.update_actor_graphic
      hudell_orange_movement_game_interpreter_command_201_B
    end
  end
end

class Game_Character < Game_CharacterBase
  def turn_toward_player
    sx = distance_x_from($game_player.float_x)
    sy = distance_y_from($game_player.float_y)

    if sx.abs < 1 && sy.abs < 1
      set_direction(10 - $game_player.direction)
    else
      if sx.abs > sy.abs
        set_direction(sx > 0 ? 4 : 6)
      elsif sy != 0
        set_direction(sy > 0 ? 8 : 2)
      end
    end
  end

  def turn_away_from_player
    sx = distance_x_from($game_player.float_x)
    sy = distance_y_from($game_player.float_y)

    if sx.abs < 1 && sy.abs < 1
      set_direction($game_player.direction)
    else
      if sx.abs > sy.abs
        set_direction(sx > 0 ? 6 : 4)
      elsif sy != 0
        set_direction(sy > 0 ? 2 : 8)
      end
    end
  end
end

class Game_Event < Game_Character
  attr_reader :erased
  
  if OrangeMovement::Use_Event_Hitboxes == true
    include OrangeMovement

    def get_config(regex, default)
      return default if @list.nil?

      @list.each do |command|
        if command.code == 108 || command.code == 408
          begin
            result = command.parameters[0].scan(regex)
            unless result.nil?
              value = result[0][0].to_i
              return value
            end
          rescue
          end
        end
      end

      default
    end

    def hitbox_x_size
      if @hitbox_x_size.nil?
        regex = /hitbox\_x_*=_*(.*)$/
        @hitbox_x_size = get_config(regex, 0)
      end

      @hitbox_x_size
    end

    def hitbox_y_size
      if @hitbox_y_size.nil?
        regex = /hitbox\_y_*=_*(.*)$/
        @hitbox_y_size = get_config(regex, 0)
      end

      @hitbox_y_size
    end

    def hitbox_h_size
      if @hitbox_h_size.nil?
        regex = /hitbox\_width_*=_*(.*)$/
        @hitbox_h_size = get_config(regex, 1)
      end

      @hitbox_h_size
    end

    def hitbox_v_size
      if @hitbox_v_size.nil?
        regex = /hitbox\_height_*=_*(.*)$/
        @hitbox_v_size = get_config(regex, 1)
      end

      @hitbox_v_size
    end

    def uses_default_hitbox?
      return false unless @hitbox_x_size == 0
      return false unless @hitbox_y_size == 0
      return false unless @hitbox_h_size == 1
      return false unless @hitbox_v_size == 1
      true
    end

    def left_x
      @x + hitbox_x_size
    end

    def right_x
      left_x + hitbox_h_size
    end

    def top_y
      @y + hitbox_y_size
    end

    def bottom_y
      top_y + hitbox_v_size
    end

    alias :hudell_orange_movement_event_hitboxes_pos? :pos?
    def pos?(x, y)
      if uses_default_hitbox?
        hudell_orange_movement_event_hitboxes_pos?(x, y)
      else
        left_x = @x + hitbox_x_size
        right_x = left_x + hitbox_h_size
        top_y = @y + hitbox_y_size
        bottom_y = top_y + hitbox_v_size

        x >= left_x && x < right_x && y >= top_y && y < bottom_y
      end
    end

    #This method is made to ensure compatibility with effectus. It won't do anything if Effectus isn't loaded.
    alias :hudell_orange_movement_event_hitboxes_game_event_refresh :refresh
    def refresh
      hudell_orange_movement_event_hitboxes_game_event_refresh

      unless uses_default_hitbox?
        if @ms_effectus_position_registered
          unless @hudell_ms_effectus_position_registered
            $game_map.ms_effectus_event_pos[@y * $game_map.width + @x].delete(self)

            for x in (left_x.floor)..(right_x.ceil - 1)
              for y in (top_y.floor)..(bottom_y.ceil - 1)
                $game_map.ms_effectus_event_pos[y * $game_map.width + x] << self
              end
            end
          end
          
          @hudell_ms_effectus_position_registered = true
        end
      end
    end

    alias :hudell_orange_movement_game_event_setup_page :setup_page
    def setup_page(new_page)
      hudell_orange_movement_game_event_setup_page(new_page)

      if @hudell_ms_effectus_position_registered
        for x in (left_x.floor)..(right_x.ceil - 1)
          for y in (top_y.floor)..(bottom_y.ceil - 1)
            $game_map.ms_effectus_event_pos[y * $game_map.width + x].delete(self)
          end
        end
        @hudell_ms_effectus_position_registered = false
      end

      @hitbox_x_size = nil
      @hitbox_y_size = nil
      @hitbox_h_size = nil
      @hitbox_v_size = nil
    end
  end
end
