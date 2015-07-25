#------------------------------------------------------------
#------------------------------------------------------------
#---------------------  EVENT SPEED FIX  --------------------
#------------------------------------------------------------
#------------------------------------------------------------
#
#
# English:
# This script fixes a problem where events configured with the same speed as the player
# were unable to keep up the speed
#
# Português:
# Este script corrige um problema onde eventos configurados com a mesma velocidade que o jogador
# não andavam realmente na mesma velocidade

class Game_Event < Game_Character
  alias :hudell_event_movement_delay_fix_stop_count_threshold :stop_count_threshold
  #
  # Return the default stop_count_threshold less 1, because "update_self_movement" uses ">" instead of ">="
  # Changing it here instead of update_self_movement is better for compatibility.
  #
  # Retorna o valor padrão de stop_count_threshold menos 1, porque o método "update_self_movement" usa ">" ao invés de ">="
  # Mudar aqui ao invés de mudar no update_self_movement é melhor para compatibilidade
  def stop_count_threshold
    hudell_event_movement_delay_fix_stop_count_threshold - 1
  end
  #
  # Adds "update_move" at the end of the update_self_movement method, to make sure the event start moving in the same frame
  #
  # Adiciona "update_move" no final do método update_self_movement, para garantir que o evento comece a se mover no mesmo frame
  alias :hudell_event_movement_delay_fix_update_self_movement :update_self_movement
  def update_self_movement
    hudell_event_movement_delay_fix_update_self_movement
    update_move if moving?
  end

  #
  # Adds "update_move" at the end of the update_routine_move method, to make sure the event start moving in the same frame
  # Also keeps @wait_count with zero if the event is using a high frequency
  #
  # Adiciona "update_move" no final do método update_routine_move, para garantir que o evento comece a se mover no mesmo frame
  # Também mantém @wait_count com valor zero se o evento está usando uma frequência alta
  alias :hudell_event_movement_delay_fix_update_routine_move :update_routine_move
  def update_routine_move
    @wait_count = 0 if @move_frequency == 5
    hudell_event_movement_delay_fix_update_routine_move 
    update_move if moving?
  end
end
