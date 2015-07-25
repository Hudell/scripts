#------------------------------------------------------------
#------------------------------------------------------------
#---------------------  EVENT HITBOXES  ---------------------
#------------------------------------------------------------
#------------------------------------------------------------
#
# Script created by Hudell (www.hudell.com)
# Version: 1.0
# You're free to use this script on any project
#
# Change Log:
#
# v1.0 - 2015-07-25
# => Created the scripted
#
#
#------------------------------------------------------------
#------------------------------------------------------------
#-----------------------  HOW TO USE  -----------------------
#------------------------------------------------------------
#------------------------------------------------------------
#
# In any event that you want to change the size, add any of those settings in a comment:
#
# hitbox_y=0
# hitbox_x=0
# hitbox_height=1
# hitbox_width=1
#
# Change the values as you need. Only integer values are support. A height of 1 means the event is 1 tile high. A height of 2 means the event is two tiles high
# You need to use negative x/y values to move the hitbox left/up.
#
#
#------------------------------------------------------------
#------------------------------------------------------------
#---------------  DON'T EDIT AFTER THIS LINE  ---------------
#------------------------------------------------------------
#------------------------------------------------------------

class Game_Event < Game_Character
  attr_writer :hitbox_x
  attr_writer :hitbox_y
  attr_writer :hitbox_width
  attr_writer :hitbox_height

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

  def hitbox_x
    if @hitbox_x.nil?
      regex = /hitbox\_x_*=_*(.*)$/
      @hitbox_x = get_config(regex, 0)
    end

    @hitbox_x
  end

  def hitbox_y
    if @hitbox_y.nil?
      regex = /hitbox\_y_*=_*(.*)$/
      @hitbox_y = get_config(regex, 0)
    end

    @hitbox_y
  end

  def hitbox_width
    if @hitbox_width.nil?
      regex = /hitbox\_width_*=_*(.*)$/
      @hitbox_width = get_config(regex, 1)
    end

    @hitbox_width
  end

  def hitbox_height
    if @hitbox_height.nil?
      regex = /hitbox\_height_*=_*(.*)$/
      @hitbox_height = get_config(regex, 1)
    end

    @hitbox_height
  end

  def left_x
    @x + hitbox_x
  end

  def right_x
    @x + hitbox_x + hitbox_width
  end

  def top_y
    @y + hitbox_y
  end

  def bottom_y
    @y + hitbox_y + hitbox_height
  end

  def pos?(x, y)
    x >= left_x && x < right_x && y >= top_y && y < bottom_y
  end
end
