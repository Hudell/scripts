#This patch fixes the problem that caused the player to be stuck after being blown away
#Este patch corrige o problem que fazia o personagem ficar preso depois de ser arremessado por um ataque

class Game_Player < Game_Character
  def blow(d, power = 1)
      return unless can_blow? 
      jump(0,0)
      self.battler.invunerable_duration = 30 if self.battler.invunerable_duration <= 0
      if self.is_a?(Game_Event)
         @collision_attack = false  
      end
      @knock_back_duration = self.battler.knockback_duration 
      refresh_sensor if self.is_a?(Game_Event)
      pre_direction = self.direction
      pre_direction_fix = self.direction_fix
      self.turn_reverse(d)      
      self.direction_fix = true
      power.times do
        OrangeMovement::Tile_Sections.times do
          case d 
             when 2; @y += OrangeMovement::Step_Size if passable?(@x, @y, d)
             when 4; @x -= OrangeMovement::Step_Size if passable?(@x, @y, d)
             when 6; @x += OrangeMovement::Step_Size if passable?(@x, @y, d)
             when 8; @y -= OrangeMovement::Step_Size if passable?(@x, @y, d)
          end
        end
      end
      self.direction_fix = pre_direction_fix
      self.direction = pre_direction
  end  
end
